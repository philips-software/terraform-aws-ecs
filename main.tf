terraform {
  required_version = ">= 0.8"
}

# EC2
locals {
  asg_tags = "${merge(map("Name", format("%s-ecs", var.environment)),
              map("Environment", format("%s", var.environment)),
              var.tags)}"
}

data "null_data_source" "asg_tags" {
  count = "${length(local.asg_tags)}"

  inputs = {
    key                 = "${element(keys(local.asg_tags), count.index)}"
    value               = "${element(values(local.asg_tags), count.index)}"
    propagate_at_launch = "true"
  }
}

resource "aws_autoscaling_group" "ecs_instance" {
  name                      = "${var.environment}-ecs-cluster-as-group"
  vpc_zone_identifier       = ["${split(",", var.subnet_ids)}"]
  min_size                  = "${var.min_instance_count}"
  max_size                  = "${var.max_instance_count}"
  desired_capacity          = "${var.desired_instance_count}"
  health_check_grace_period = 300
  launch_configuration      = "${aws_launch_configuration.ecs_instance.name}"
  tags                      = ["${data.null_data_source.asg_tags.*.outputs}"]
}

resource "aws_launch_configuration" "ecs_instance" {
  security_groups      = ["${var.security_group_id}"]
  key_name             = "${var.key_name}"
  image_id             = "${lookup(var.ecs_optimized_amis, var.aws_region)}"
  user_data            = "${var.user_data}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${var.ecs_instance_role_name}"

  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${cluster_name}"
}

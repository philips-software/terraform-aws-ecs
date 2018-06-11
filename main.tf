terraform {
  required_version = ">= 0.8"
}

# EC2

resource "aws_autoscaling_group" "ecs_instance" {
  name                      = "${var.environment}-as-group"
  vpc_zone_identifier       = ["${split(",", var.subnet_ids)}"]
  min_size                  = "${var.min_instance_count}"
  max_size                  = "${var.max_instance_count}"
  desired_capacity          = "${var.desired_instance_count}"
  health_check_grace_period = 300
  launch_configuration      = "${aws_launch_configuration.ecs_instance.name}"

  tag {
    key                 = "Name"
    value               = "${var.environment}-ecs"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "ecs_instance" {
  security_groups      = ["${aws_security_group.instance_sg.id}"]
  key_name             = "${var.key_name}"
  image_id             = "${lookup(var.ecs_optimized_amis, var.aws_region)}"
  user_data            = "${var.user_data}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"

  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.environment}-ecs-cluster-sg"
  description = "controls access to ecs-cluster instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol  = "tcp"
    from_port = 0
    to_port   = 65535

    cidr_blocks = [
      "${var.vpc_cidr}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-ecs-cluster-sg"
    Environment = "${var.environment}"
  }
}

## ECS
#
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"
}

data "template_file" "service_role_trust_policy" {
  template = "${file("${path.module}/policies/service-role-trust-policy.json")}"
}

resource "aws_iam_role" "ecs_service" {
  name               = "${var.environment}-ecs-role"
  assume_role_policy = "${data.template_file.service_role_trust_policy.rendered}"
}

data "template_file" "service_role_policy" {
  template = "${file("${path.module}/policies/service-role-policy.json")}"
}

resource "aws_iam_role_policy" "service_role_policy" {
  name   = "${var.environment}-ecs-service-policy"
  role   = "${aws_iam_role.ecs_service.name}"
  policy = "${data.template_file.service_role_policy.rendered}"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.environment}-ecs-instance-profile"
  role = "${aws_iam_role.ecs_instance.name}"
}

data "template_file" "instance_role_trust_policy" {
  template = "${file("${path.module}/policies/instance-role-trust-policy.json")}"
}

resource "aws_iam_role" "ecs_instance" {
  name               = "${var.environment}-ecs-instance-role"
  assume_role_policy = "${data.template_file.instance_role_trust_policy.rendered}"
}

data "template_file" "instance_profile" {
  template = "${file("${path.module}/policies/instance-profile-policy.json")}"
}

resource "aws_iam_role_policy" "ecs_instance" {
  name   = "${var.environment}-ecs-instance-role"
  role   = "${aws_iam_role.ecs_instance.name}"
  policy = "${data.template_file.instance_profile.rendered}"
}

# EC2
locals {
  asg_tags = merge(
    {
      "Name" = format("%s-ecs", var.environment)
    },
    {
      "Environment" = format("%s", var.environment)
    },
    {
      "Project" = format("%s", var.project)
    },
    var.tags,
  )
}

resource "aws_autoscaling_group" "ecs_instance_dynamic" {
  count                     = var.dynamic_scaling ? 1 : 0
  name                      = "${var.environment}-ecs-cluster-as-group"
  vpc_zone_identifier       = split(",", var.subnet_ids)
  min_size                  = var.min_instance_count
  max_size                  = var.max_instance_count
  health_check_grace_period = 300
  launch_configuration      = aws_launch_configuration.ecs_instance.name

  dynamic "tag" {
    for_each = local.asg_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_group" "ecs_instance" {
  count                     = var.dynamic_scaling ? 0 : 1
  name                      = "${var.environment}-ecs-cluster-as-group"
  vpc_zone_identifier       = split(",", var.subnet_ids)
  min_size                  = var.min_instance_count
  max_size                  = var.max_instance_count
  desired_capacity          = var.desired_instance_count
  health_check_grace_period = 300
  launch_configuration      = aws_launch_configuration.ecs_instance.name

  dynamic "tag" {
    for_each = local.asg_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_policy" "scaleOut" {
  count              = var.dynamic_scaling ? 1 : 0
  name               = "ScaleOut"
  scaling_adjustment = abs(var.dynamic_scaling_adjustment)
  policy_type        = "SimpleScaling"
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 600
  autoscaling_group_name = element(
    aws_autoscaling_group.ecs_instance_dynamic.*.name,
    count.index,
  )
}

resource "aws_autoscaling_policy" "scaleIn" {
  count              = var.dynamic_scaling ? 1 : 0
  name               = "ScaleIn"
  scaling_adjustment = -1 * abs(var.dynamic_scaling_adjustment)
  policy_type        = "SimpleScaling"
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 120
  autoscaling_group_name = element(
    aws_autoscaling_group.ecs_instance_dynamic.*.name,
    count.index,
  )
}

data "aws_ami" "ecs" {
  most_recent        = var.ecs_ami_latest
  include_deprecated = var.ecs_ami_include_deprecated

  dynamic "filter" {
    for_each = var.ecs_ami_filter
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      name   = filter.value["name"]
      values = tolist([filter.value["values"]])
    }
  }

  owners = var.ecs_ami_owners
}

resource "aws_launch_configuration" "ecs_instance" {
  security_groups = [aws_security_group.instance_sg.id]
  key_name        = var.key_name
  image_id        = data.aws_ami.ecs.id

  user_data            = var.user_data
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_instance.name

  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.environment}-ecs-cluster-sg"
  description = "controls access to ecs-cluster instances"
  vpc_id      = var.vpc_id

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0

    cidr_blocks = concat([var.vpc_cidr], var.additional_cidr_blocks)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("%s-ecs-cluster-sg", var.environment)
    },
    {
      "Environment" = format("%s", var.environment)
    },
    {
      "Project" = format("%s", var.project)
    },
    var.tags,
  )
}

## ECS
#
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"
}

data "template_file" "service_role_trust_policy" {
  template = file("${path.module}/policies/service-role-trust-policy.json")
}

resource "aws_iam_role" "ecs_service" {
  name               = "${var.environment}-ecs-role"
  assume_role_policy = data.template_file.service_role_trust_policy.rendered
}

data "template_file" "service_role_policy" {
  template = file("${path.module}/policies/service-role-policy.json")
}

resource "aws_iam_role_policy" "service_role_policy" {
  name   = "${var.environment}-ecs-service-policy"
  role   = aws_iam_role.ecs_service.name
  policy = data.template_file.service_role_policy.rendered
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.environment}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
}

data "template_file" "instance_role_trust_policy" {
  template = file("${path.module}/policies/instance-role-trust-policy.json")
}

resource "aws_iam_role" "ecs_instance" {
  name               = "${var.environment}-ecs-instance-role"
  assume_role_policy = data.template_file.instance_role_trust_policy.rendered
}

data "template_file" "instance_profile" {
  template = file("${path.module}/policies/instance-profile-policy.json")
}

resource "aws_iam_role_policy" "ecs_instance" {
  name   = "${var.environment}-ecs-instance-role"
  role   = aws_iam_role.ecs_instance.name
  policy = data.template_file.instance_profile.rendered
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  count      = var.enable_session_manager ? 1 : 0
}


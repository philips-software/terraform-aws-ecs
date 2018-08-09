resource "aws_security_group" "lb_sg" {
  name        = "${var.environment}-${var.service_name}-lb-sg"
  description = "controls access to the application LB"

  vpc_id = "${var.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = "${var.alb_port}"
    to_port     = "${var.alb_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-ecs-cluster-sg"
    Environment = "${var.environment}"
  }
}

## ECS

data "template_file" "task_definition" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    image_url          = "${var.image_url}"
    name               = "${var.service_name}"
    port               = "${var.container_port}"
    cpu                = "${var.container_cpu == "" ? "": "\"cpu\": ${var.container_cpu},"}"
    memory_reservation = "${var.container_memory_reservation == "" ? "4": "${var.container_memory_reservation}"}"
    memory             = "${var.container_memory == "" ? "": "\"memory\": ${var.container_memory},"}"

    log_group_region = "${var.aws_region}"
    log_group_name   = "${aws_cloudwatch_log_group.service.name}"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                = "${var.environment}-${var.service_name}"
  container_definitions = "${data.template_file.task_definition.rendered}"
}

resource "aws_ecs_service" "main" {
  name            = "${var.service_name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  desired_count   = 1
  iam_role        = "${var.ecs_service_role_name}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.main.id}"
    container_name   = "${var.service_name}"
    container_port   = "${var.container_port}"
  }

  depends_on = ["aws_alb_listener.main"]
}

## ALB
#
resource "aws_alb_target_group" "main" {
  port     = "${var.alb_port}"
  protocol = "${var.alb_protocol}"
  vpc_id   = "${var.vpc_id}"

  tags {
    Name        = "${var.environment}-${var.service_name}"
    Environment = "${var.environment}"
    Application = "${var.service_name}"
  }
}

resource "aws_alb" "main" {
  subnets         = ["${split(",", var.public_subnets)}"]
  security_groups = ["${aws_security_group.lb_sg.id}"]

  tags {
    Name        = "${var.environment}-${var.service_name}"
    Environment = "${var.environment}"
    Application = "${var.service_name}"
  }
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "${var.alb_port}"
  protocol          = "${var.alb_protocol}"

  default_action {
    target_group_arn = "${aws_alb_target_group.main.id}"
    type             = "forward"
  }
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "service" {
  name = "${var.environment}-ecs-group/${var.service_name}"
}

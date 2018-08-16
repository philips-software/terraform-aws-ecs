module "blog" {
  source  = "philips-software/ecs-service/aws"
  version = "1.0.0"

  environment = "${var.environment}"
  project     = "${var.project}"

  ecs_cluster_id   = "${module.ecs_cluster.id}"
  ecs_cluster_name = "${module.ecs_cluster.name}"
  docker_image     = "npalm/040code.github.io"
  service_name     = "${local.service_name}"

  // ALB part, over http without dns entry
  ecs_service_role      = "${module.ecs_cluster.service_role_name}"
  enable_alb            = true
  internal_alb          = false
  vpc_id                = "${module.vpc.vpc_id}"
  subnet_ids            = "${join(",", module.vpc.public_subnets)}"
  alb_port              = 80
  alb_protocol          = "HTTP"
  container_ssl_enabled = false
  container_port        = "80"

  // DNS specifc settings for the ALB, disalbed
  enable_dns = false

  // Monitoring settings, disabled
  enable_monitoring        = true
  monitoring_sns_topic_arn = "${aws_sns_topic.monitoring.arn}"

  // Enables logging to other targets (default is STDOUT)
  // For CloudWatch logging, make sure the awslogs-group exists
  docker_logging_config = <<EOF
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.default.name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${local.service_name}"
        }
      }
    EOF
}

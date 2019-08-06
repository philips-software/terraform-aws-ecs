# CloudWatch Logs
resource "aws_cloudwatch_log_group" "default" {
  name = "${var.environment}-ecs-group"
}

resource "aws_sns_topic" "monitoring" {
  name = "${var.environment}-monitoring"
}

resource "aws_cloudwatch_log_metric_filter" "application_error_filter" {
  name           = "${var.environment} - application errors"
  pattern        = "ERROR"
  log_group_name = aws_cloudwatch_log_group.default.name

  metric_transformation {
    name          = "${var.environment} - application errors"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "application_error_alarm" {
  alarm_name                = "${var.environment} - application errors"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.application_error_filter.id
  namespace                 = "AWS/Logs"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "This metric monitors the number of errors during the last minute"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_usage_high" {
  alarm_name          = "CPUUtilization >= 90%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "90"
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = module.ecs_cluster.autoscaling_group_name
  }

  alarm_description = "This metric monitors cpu utilization"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibilty in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [module.ecs_cluster.autoscaling_policy_scaleOut_arn]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_usage_low" {
  alarm_name          = "CPUUtilization < 30%"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = module.ecs_cluster.autoscaling_group_name
  }

  alarm_description = "This metric monitors cpu utilization"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibilty in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [module.ecs_cluster.autoscaling_policy_scaleIn_arn]
}


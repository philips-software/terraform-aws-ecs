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
  log_group_name = "${aws_cloudwatch_log_group.default.name}"

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
  metric_name               = "${aws_cloudwatch_log_metric_filter.application_error_filter.id}"
  namespace                 = "AWS/Logs"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "This metric monitors the number of errors during the last minute"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
}

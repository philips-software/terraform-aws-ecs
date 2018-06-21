output "service_url" {
  value = "${aws_alb_listener.main.protocol}://${aws_alb.main.dns_name}:${aws_alb_listener.main.port}"
}

output "id" {
  description = "Id of the cluster."
  value       = "${aws_ecs_cluster.main.id}"
}

output "name" {
  description = "Name of the cluster."
  value       = "${aws_ecs_cluster.main.name}"
}

output "service_role_name" {
  description = "Created IAM service role name."
  value       = "${aws_iam_role.ecs_service.name}"
}

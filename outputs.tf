output "id" {
  description = "Id of the cluster."
  value       = "${aws_ecs_cluster.main.id}"
}

output "name" {
  description = "Name of the cluster."
  value       = "${aws_ecs_cluster.main.name}"
}

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

output "iam_instance_profile_name" {
  description = ""
  value       = "${aws_iam_instance_profile.ecs_instance.name}"
}

output "instance_sg_id" {
  description = ""
  value       = "${aws_security_group.instance_sg.id}"
}
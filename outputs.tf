output "id" {
  description = "Id of the cluster."
  value       = aws_ecs_cluster.main.id
}

output "name" {
  description = "Name of the cluster."
  value       = local.cluster_name
}

output "service_role_name" {
  description = "Created IAM service role name."
  value       = aws_iam_role.ecs_service.name
}

output "iam_instance_profile_arn" {
  description = "Created IAM instance profile."
  value       = aws_iam_instance_profile.ecs_instance.arn
}

output "instance_sg_id" {
  description = "Created security group for cluster instances."
  value       = aws_security_group.instance_sg.id
}

output "autoscaling_group_name" {
  description = "Created auto scaling group for cluster."

  value = aws_autoscaling_group.ecs_instance.name
}

output "autoscaling_group_arn" {
  description = "Created auto scaling group for cluster."

  value = aws_autoscaling_group.ecs_instance.arn
}

output "autoscaling_policy_scaleIn_arn" {
  description = "Created auto scaling group policy for scaleIn."
  value       = join("", aws_autoscaling_policy.scaleIn.*.arn)
}

output "autoscaling_policy_scaleOut_arn" {
  description = "Created auto scaling group policy for scaleOut."
  value       = join("", aws_autoscaling_policy.scaleOut.*.arn)
}

output "capacity_provider" {
  description = "Name of the capacity provider"
  value = join("", aws_ecs_capacity_provider.scaling.*.name)
}

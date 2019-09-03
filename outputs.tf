output "id" {
  description = "Id of the cluster."
  value       = aws_ecs_cluster.main.id
}

output "name" {
  description = "Name of the cluster."
  value       = aws_ecs_cluster.main.name
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

  value = element(
    compact(
      concat(
        aws_autoscaling_group.ecs_instance.*.name,
        aws_autoscaling_group.ecs_instance_dynamic.*.name,
      ),
    ),
    0,
  )
}

output "autoscaling_policy_scaleIn_arn" {
  description = "Created auto scaling group policy for scaleIn."
  value       = join("", aws_autoscaling_policy.scaleIn.*.arn)
}

output "autoscaling_policy_scaleOut_arn" {
  description = "Created auto scaling group policy for scaleOut."
  value       = join("", aws_autoscaling_policy.scaleOut.*.arn)
}


output "pod_execution_role_arn" {
  description = "Pod execution role ARN"
  value       = aws_iam_role.pod_execution_role.arn
}

output "secrets_manager_policy_arn" {
  description = "Secrets manager policy ARN"
  value       = aws_iam_policy.secrets_manager.arn
}

output "efs_access_policy_arn" {
  description = "EFS access policy ARN"
  value       = aws_iam_policy.efs_access.arn
}
output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}

output "secret_arn" {
  description = "Secret ARN"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.rds.id
}
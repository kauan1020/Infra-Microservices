output "jwt_secret_arn" {
  description = "JWT secret ARN"
  value       = aws_secretsmanager_secret.jwt_secret.arn
}

output "redis_secret_arn" {
  description = "Redis secret ARN"
  value       = aws_secretsmanager_secret.redis_secret.arn
}

output "notification_secret_arn" {
  description = "Notification secret ARN"
  value       = aws_secretsmanager_secret.notification_secret.arn
}

output "auth_secret_arn" {
  description = "Auth secret ARN"
  value       = aws_secretsmanager_secret.auth_secret.arn
}

output "jwt_secret_name" {
  description = "JWT secret name"
  value       = aws_secretsmanager_secret.jwt_secret.name
}

output "redis_secret_name" {
  description = "Redis secret name"
  value       = aws_secretsmanager_secret.redis_secret.name
}

output "notification_secret_name" {
  description = "Notification secret name"
  value       = aws_secretsmanager_secret.notification_secret.name
}

output "auth_secret_name" {
  description = "Auth secret name"
  value       = aws_secretsmanager_secret.auth_secret.name
}
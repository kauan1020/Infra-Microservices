
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "rds_auth_endpoint" {
  description = "RDS Auth endpoint"
  value       = module.rds_auth.db_endpoint
}

output "rds_video_endpoint" {
  description = "RDS Video endpoint"
  value       = module.rds_video.db_endpoint
}

output "rds_auth_secret_arn" {
  description = "RDS Auth secret ARN"
  value       = module.rds_auth.secret_arn
}

output "rds_video_secret_arn" {
  description = "RDS Video secret ARN"
  value       = module.rds_video.secret_arn
}

output "jwt_secret_arn" {
  description = "JWT secret ARN"
  value       = module.secrets.jwt_secret_arn
}

output "redis_secret_arn" {
  description = "Redis secret ARN"
  value       = module.secrets.redis_secret_arn
}

output "notification_secret_arn" {
  description = "Notification secret ARN"
  value       = module.secrets.notification_secret_arn
}

output "auth_secret_arn" {
  description = "Auth secret ARN"
  value       = module.secrets.auth_secret_arn
}

# Adicione os outputs de name que estão faltando
output "jwt_secret_name" {
  description = "JWT secret name"
  value       = module.secrets.jwt_secret_name
}

output "redis_secret_name" {
  description = "Redis secret name"
  value       = module.secrets.redis_secret_name
}

output "notification_secret_name" {
  description = "Notification secret name"
  value       = module.secrets.notification_secret_name
}

output "auth_secret_name" {
  description = "Auth secret name"
  value       = module.secrets.auth_secret_name
}

output "ecr_repositories" {
  description = "ECR repository URLs"
  value       = module.ecr.repository_urls
}

output "efs_file_system_id" {
  description = "EFS file system ID"
  value       = module.efs.file_system_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
}
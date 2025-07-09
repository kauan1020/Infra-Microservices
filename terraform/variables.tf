variable "project_name" {
  description = "Project name"
  type        = string
  default     = "fiap-x"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.28"
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage"
  type        = number
  default     = 20
}

variable "ecr_repositories" {
  description = "ECR repositories to create"
  type        = list(string)
  default     = ["auth-service", "video-service"]
}

variable "gmail_email" {
  description = "Gmail email for notifications"
  type        = string
  sensitive   = true
}

variable "gmail_app_password" {
  description = "Gmail app password for notifications"
  type        = string
  sensitive   = true
}

variable "admin_emails" {
  description = "Admin emails for notifications (comma-separated)"
  type        = string
  default     = ""
}
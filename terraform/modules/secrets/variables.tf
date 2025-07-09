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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

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
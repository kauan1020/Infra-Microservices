resource "random_password" "jwt_secret" {
  length  = 64
  special = true
}

resource "random_password" "redis_password" {
  length  = 32
  special = true
}

resource "random_password" "auth_api_key" {
  length  = 32
  special = false
}

resource "random_password" "notification_api_key" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name = "${var.project_name}-${var.environment}-jwt-secret"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id = aws_secretsmanager_secret.jwt_secret.id
  secret_string = jsonencode({
    secret-key = random_password.jwt_secret.result
  })
}

resource "aws_secretsmanager_secret" "redis_secret" {
  name = "${var.project_name}-${var.environment}-redis-secret"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "redis_secret" {
  secret_id = aws_secretsmanager_secret.redis_secret.id
  secret_string = jsonencode({
    password = random_password.redis_password.result
  })
}

resource "aws_secretsmanager_secret" "notification_secret" {
  name = "${var.project_name}-${var.environment}-notification-secret"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "notification_secret" {
  secret_id = aws_secretsmanager_secret.notification_secret.id
  secret_string = jsonencode({
    api_key = random_password.notification_api_key.result
    gmail_email = var.gmail_email
    gmail_app_password = var.gmail_app_password
    from_email = var.gmail_email
    from_name = "FIAP X Video Processing"
    admin_emails = var.admin_emails
  })
}

resource "aws_secretsmanager_secret" "auth_secret" {
  name = "${var.project_name}-${var.environment}-auth-secret"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "auth_secret" {
  secret_id = aws_secretsmanager_secret.auth_secret.id
  secret_string = jsonencode({
    api_key = random_password.auth_api_key.result
  })
}
resource "aws_iam_policy" "secrets_manager" {
  name        = "${var.project_name}-${var.environment}-secrets-manager"
  description = "Policy for accessing secrets manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:${var.project_name}-${var.environment}-*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "efs_access" {
  name        = "${var.project_name}-${var.environment}-efs-access"
  description = "Policy for accessing EFS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticfilesystem:AccessedViaMountTarget",
          "elasticfilesystem:AccessPoint",
          "elasticfilesystem:AccessPointsForFileSystem",
          "elasticfilesystem:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "pod_execution_role" {
  name = "${var.project_name}-${var.environment}-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "${var.oidc_issuer_url}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
        Principal = {
          Federated = var.oidc_provider_arn
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pod_execution_role_secrets" {
  role       = aws_iam_role.pod_execution_role.name
  policy_arn = aws_iam_policy.secrets_manager.arn
}

resource "aws_iam_role_policy_attachment" "pod_execution_role_efs" {
  role       = aws_iam_role.pod_execution_role.name
  policy_arn = aws_iam_policy.efs_access.arn
}
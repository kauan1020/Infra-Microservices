resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-${var.service_name}-rds-sg"
  description = "Security group for RDS ${var.service_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.service_name}-rds-sg"
  })
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-${var.service_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.service_name}-db-subnet-group"
  })
}

resource "random_password" "db_password" {
  length  = 32
  special = false
}

resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-${var.service_name}-db"

  engine            = "postgres"
  engine_version    = "15.7"
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.service_name == "auth" ? "fiap_x_auth" : "video_processing"
  username = "dbadmin"
  password = random_password.db_password.result

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.service_name}-db"
  })
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.project_name}-${var.environment}-${var.service_name}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = aws_db_instance.main.username
    password = random_password.db_password.result
    engine   = "postgres"
    host     = aws_db_instance.main.endpoint
    port     = aws_db_instance.main.port
    dbname   = aws_db_instance.main.db_name
  })
}
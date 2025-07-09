module "secrets" {
  source = "./modules/secrets"
  gmail_email        = var.gmail_email
  gmail_app_password = var.gmail_app_password
  admin_emails       = var.admin_emails

  tags = local.common_tags
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  tags = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = var.cluster_version

  vpc_id                = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
  node_min_size       = var.node_min_size

  tags = local.common_tags
}

module "rds_auth" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment
  service_name = "auth"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  db_instance_class = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  tags = local.common_tags
}

module "rds_video" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment
  service_name = "video"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  db_instance_class = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage

  tags = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment

  repositories = var.ecr_repositories

  tags = local.common_tags
}

module "efs" {
  source = "./modules/efs"

  project_name = var.project_name
  environment  = var.environment

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
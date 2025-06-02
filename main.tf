terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    # These values should be provided during terraform init
    # bucket         = "your-terraform-state-bucket"
    # key            = "landing-zone/terraform.tfstate"
    # region         = "us-west-2"
    # dynamodb_table = "terraform-state-lock"
    # encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.tags,
      {
        Environment = var.environment
        ManagedBy   = "Terraform"
        Owner       = var.org_name
      }
    )
  }
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  environment        = var.environment
  org_name          = var.org_name
  break_glass_users = var.break_glass_users
  admin_users       = var.admin_users
  readonly_users    = var.readonly_users
  sso_provider      = var.sso_provider
}

# Network Module
module "network" {
  source = "./modules/network"

  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  subnet_config   = var.subnet_config
  enable_flow_logs = var.enable_flow_logs
}

# Security Module
module "security" {
  source = "./modules/security"

  environment        = var.environment
  enable_guardduty   = var.enable_guardduty
  enable_config      = var.enable_config
  log_retention_days = var.log_retention_days
  vpc_id            = module.network.vpc_id
}

# Shared Services Module
module "shared_services" {
  source = "./modules/shared-services"

  environment        = var.environment
  log_retention_days = var.log_retention_days
  vpc_id            = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
} 
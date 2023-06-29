terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

terraform {
  cloud {
    organization = "branber"

    workspaces {
      name = "pronto"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  token = var.github_access_token
  owner = var.github_organization
}

// todo: remote s3 bucket for tf-state
module "networking" {
  source = "./modules/networking"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.networking.pronto_vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "secrets" {
  source = "./modules/secrets"
}

module "ecr" {
  source = "./modules/ecr"
}

module "backend" {
  source                    = "./modules/backend"
  vpc_id                    = module.networking.pronto_vpc_id
  private_subnet_ids        = module.networking.private_subnet_ids
  allow_all_egress_id       = module.security_groups.allow_all_egress
  GOOGLE_CLIENT_ID          = var.GOOGLE_CLIENT_ID
  GOOGLE_CLIENT_SECRET_ID   = var.GOOGLE_CLIENT_SECRET_ID
  JWT_SECRET                = var.JWT_SECRET
  REFRESH_SECRET            = var.REFRESH_SECRET
  TOKEN_ENCRYPT_SECRET      = var.TOKEN_ENCRYPT_SECRET
  vpc_access_policy_arn     = module.iam.vpc_access_policy_arn
  cloudwatch_logging_arn    = module.iam.cloudwatch_logging_arn
  pronto_ecr_repo_url       = module.ecr.repository_url
  ecr_image_pull_policy_arn = module.ecr.ecr_image_pull_policy_arn
  db_secret_id              = module.secrets.db_secret_id
  db_secret_version_id      = module.secrets.db_secret_version_id
}

module "cicd" {
  source                                         = "./modules/cicd"
  vpc_id                                         = module.networking.pronto_vpc_id
  allow_all_egress_id                            = module.security_groups.allow_all_egress
  private_subnet_ids                             = module.networking.private_subnet_ids
  private_subnet_arns                            = module.networking.private_subnet_arns
  github_access_token                            = var.github_access_token
  pronto_ecr_repo_arn                            = module.ecr.arn
  pronto_ecr_repo_url                            = module.ecr.repository_url
  ecr_image_pull_policy_arn                      = module.ecr.ecr_image_pull_policy_arn
  pronto_event_rule_invoke_reminder_function_arn = module.backend.pronto_event_rule_invoke_reminder_function_arn
  DATABASE_URL                                   = module.backend.DATABASE_URL
}

output "db_pass" {
  value     = module.backend.db_pass
  sensitive = false
}

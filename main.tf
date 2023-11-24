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
  source                       = "./modules/backend"
  vpc_id                       = module.networking.pronto_vpc_id
  private_subnet_ids           = module.networking.private_subnet_ids
  public_subnet_ids            = module.networking.public_subnet_ids
  allow_all_egress_id          = module.security_groups.allow_all_egress
  api_env_vars                 = module.secrets.api_env_vars
  reminder_env_vars            = module.secrets.reminder_env_vars
  frontend_env_vars            = module.secrets.frontend_env_vars
  shared_secrets               = module.secrets.shared_secrets
  vpc_access_policy_arn        = module.iam.vpc_access_policy_arn
  cloudwatch_logging_arn       = module.iam.cloudwatch_logging_arn
  pronto_backend_ecr_repo_url  = module.ecr.backend_repository_url
  pronto_frontend_ecr_repo_url = module.ecr.frontend_repository_url
  ecr_image_pull_policy_arn    = module.ecr.ecr_image_pull_policy_arn
  db_secret_id                 = module.secrets.db_secret_id
  db_secret_version_id         = module.secrets.db_secret_version_id
}

module "cicd" {
  source                                 = "./modules/cicd"
  vpc_id                                 = module.networking.pronto_vpc_id
  allow_all_egress_id                    = module.security_groups.allow_all_egress
  private_subnet_ids                     = module.networking.private_subnet_ids
  private_subnet_arns                    = module.networking.private_subnet_arns
  github_access_token                    = var.github_access_token
  pronto_backend_ecr_repo_arn            = module.ecr.backend_arn
  pronto_backend_ecr_repo_url            = module.ecr.backend_repository_url
  ecr_image_pull_policy_arn              = module.ecr.ecr_image_pull_policy_arn
  pronto_frontend_ecr_repo_url           = module.ecr.frontend_repository_url
  pronto_api_reminder_function_arn       = module.backend.pronto_api_reminder_function_arn
  DATABASE_URL                           = module.backend.DATABASE_URL
  backend_container_definitions          = module.backend.container_definitions_backend
  frontend_container_definitions         = module.backend.container_definitions_frontend
  ecs_service_backend_id                 = module.backend.ecs_service_api_id
  ecs_task_definition_backend_arn        = module.backend.ecs_task_definition_api_arn
  ecs_service_frontend_id                = module.backend.ecs_service_frontend_id
  ecs_task_definition_frontend_arn       = module.backend.ecs_task_definition_frontend_arn
  pronto_ecs_task_execution_frontend_arn = module.backend.pronto_ecs_task_execution_arn
  pronto_ecs_task_execution_backend_arn  = module.backend.pronto_ecs_task_execution_arn
  task_definition_backend                = module.backend.task_definition_backend
  task_definition_frontend               = module.backend.task_definition_frontend
  ecs_cluster_arn                        = module.backend.ecs_cluster_arn
}

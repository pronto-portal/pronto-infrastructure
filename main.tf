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

module "cicd" {
  source              = "./modules/cicd"
  vpc_id              = module.networking.pronto_vpc_id
  allow_all_egress_id = module.security_groups.allow_all_egress
  private_subnet_ids  = module.networking.private_subnet_ids
  private_subnet_arns = module.networking.private_subnet_arns
  github_access_token = var.github_access_token
}

# module "backend" {
#   source                     = "./modules/backend"
#   pronto_artifacts_s3_bucket = module.cicd.pronto_artifacts_s3_bucket
#   private_subnet_ids         = module.networking.private_subnet_ids
#   allow_all_egress_id        = module.security_groups.allow_all_egress
# }

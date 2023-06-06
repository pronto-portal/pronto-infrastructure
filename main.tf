terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    region="us-east-1"
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
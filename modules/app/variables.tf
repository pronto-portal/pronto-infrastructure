variable "private_subnet_ids" {}
variable "public_subnet_ids" {}
variable "allow_all_egress_id" {}
variable "vpc_id" {}
variable "db_secret_id" {}
variable "db_secret_version_id" {}

variable "api_env_vars" {}
variable "reminder_env_vars" {}
variable "frontend_env_vars" {}
variable "shared_secrets" {}

variable "vpc_access_policy_arn" {}
variable "cloudwatch_logging_arn" {}
variable "pronto_backend_ecr_repo_url" {}
variable "pronto_frontend_ecr_repo_url" {}
variable "ecr_image_pull_policy_arn" {}

variable "api_gateway_stage" {
  type    = string
  default = "dev"
}



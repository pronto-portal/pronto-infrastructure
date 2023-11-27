variable "vpc_id" {}
variable "allow_all_egress_id" {}
variable "private_subnet_ids" {}
variable "private_subnet_arns" {}
variable "pronto_backend_ecr_repo_arn" {}
variable "pronto_backend_ecr_repo_url" {}
variable "ecr_image_pull_policy_arn" {}
variable "pronto_api_reminder_function_arn" {}
variable "DATABASE_URL" {}

// ecs -----------------------------------------
variable "backend_container_definitions" {}
variable "frontend_container_definitions" {}

variable "ecs_service_backend_id" {}
variable "ecs_task_definition_backend_arn" {}
variable "pronto_ecs_task_execution_backend_arn" {}

variable "ecs_service_frontend_id" {}
variable "ecs_task_definition_frontend_arn" {}
variable "pronto_ecs_task_execution_frontend_arn" {}
variable "task_definition_backend" {}
variable "task_definition_frontend" {}

variable "ecs_cluster_arn" {}

// ecr
variable "pronto_frontend_ecr_repo_url" {}

// github 
variable "github_access_token" {
  type        = string
  description = "github access token taken from environment variables"
  sensitive   = true
  nullable    = false
}

variable "backend_repository_name" {
  type        = string
  description = "repository name"
  default     = "pronto-api"
}

// env vars 
variable "frontend_env_vars" {}

variable "shared_secrets" {}

variable "api_gateway_url" {}

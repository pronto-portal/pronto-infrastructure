variable "vpc_id" {}
variable "allow_all_egress_id" {}
variable "private_subnet_ids" {}
variable "private_subnet_arns" {}
variable "pronto_ecr_repo_arn" {}
variable "pronto_ecr_repo_url" {}
variable "ecr_image_pull_policy_arn" {}
variable "pronto_event_rule_invoke_reminder_function_arn" {}
variable "DATABASE_URL" {}
variable "container_definitions" {}
variable "ecs_service_id" {}
variable "ecs_task_definition_arn" {}
variable "ecs_cluster_arn" {}

variable "github_access_token" {
  type        = string
  description = "github access token taken from environment variables"
  sensitive   = true
  nullable    = false
}

variable "repository_name" {
  type        = string
  description = "repository name"
  default     = "pronto-api"
}


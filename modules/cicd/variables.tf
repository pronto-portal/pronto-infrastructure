variable "vpc_id" {}
variable "allow_all_egress_id" {}
variable "private_subnet_ids" {}
variable "private_subnet_arns" {}
variable "pronto_api_function_arn" {}
variable "pronto_api_reminder_function_arn" {}

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

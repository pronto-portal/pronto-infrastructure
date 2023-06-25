variable "private_subnet_ids" {}
variable "allow_all_egress_id" {}
variable "vpc_id" {}

variable "GOOGLE_CLIENT_ID" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "GOOGLE_CLIENT_SECRET_ID" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "JWT_SECRET" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "REFRESH_SECRET" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "TOKEN_ENCRYPT_SECRET" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "vpc_access_policy_arn" {}
variable "cloudwatch_logging_arn" {}
variable "pronto_ecr_repo_url" {}
variable "ecr_image_pull_policy_arn" {}

variable "api_gateway_stage" {
  type    = string
  default = "dev"
}

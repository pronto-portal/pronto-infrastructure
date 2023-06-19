variable "pronto_artifacts_s3_bucket" {}
variable "private_subnet_ids" {}
variable "allow_all_egress_id" {}

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

variable "api_gateway_stage" {
  type    = string
  default = "dev"
}

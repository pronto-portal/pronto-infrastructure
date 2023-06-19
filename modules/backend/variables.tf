variable "pronto_artifacts_s3_bucket" {}
variable "private_subnet_ids" {}
variable "allow_all_egress_id" {}

variable "GOOGLE_CLIENT_ID" {
  type = string
}

variable "GOOGLE_CLIENT_SECRET_ID" {
  type = string
}

variable "JWT_SECRET" {
  type = string
}

variable "REFRESH_SECRET" {
  type = string
}

variable "TOKEN_ENCRYPT_SECRET" {
  type = string
}

variable "github_access_token" {
  type = string
}

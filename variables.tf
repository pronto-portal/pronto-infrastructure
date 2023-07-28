variable "github_access_token" {
  type        = string
  description = "github access token taken from environment variables"
  sensitive   = true
  nullable    = false
}

variable "github_organization" {
  type    = string
  default = "pronto-portal"
}

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

variable "TWILIO_AUTH_TOKEN" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "TWILIO_SID" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "TWILIO_PHONE" {
  type      = string
  sensitive = true
  nullable  = false
}


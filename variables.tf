variable "github_access_token" {
    type = string
    description = "github access token taken from environment variables"
    sensitive = true
    nullable = false
}

variable "github_organization" {
    type = string
    default = "pronto-portal"
}
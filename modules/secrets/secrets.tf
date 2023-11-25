resource "random_password" "password" {
  length  = 32
  special = false
  #override_special = "-_.!~*"
}

resource "aws_secretsmanager_secret" "rds_password" {
  name = "rds_password"
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.password.result
}

data "aws_secretsmanager_secret" "api_env_vars" {
  name = "api-env-vars"
}

data "aws_secretsmanager_secret_version" "api_env_vars_version" {
  secret_id = data.aws_secretsmanager_secret.api_env_vars.id
}

data "aws_secretsmanager_secret" "reminder_env_vars" {
  name = "reminder-env-vars"
}

data "aws_secretsmanager_secret_version" "reminder_env_vars_version" {
  secret_id = data.aws_secretsmanager_secret.reminder_env_vars.id
}

data "aws_secretsmanager_secret" "frontend_env_vars" {
  name = "frontend-env-vars"
}

data "aws_secretsmanager_secret_version" "frontend_env_vars_version" {
  secret_id = data.aws_secretsmanager_secret.frontend_env_vars.id
}

data "aws_secretsmanager_secret" "shared_secrets" {
  name = "pronto-shared-secrets"
}

data "aws_secretsmanager_secret_version" "shared_secrets_version" {
  secret_id = data.aws_secretsmanager_secret.shared_secrets.id
}

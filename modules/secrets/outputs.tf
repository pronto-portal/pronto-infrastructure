output "db_secret_id" {
  value = aws_secretsmanager_secret.rds_password.id
}

output "db_secret_version_id" {
  value = aws_secretsmanager_secret_version.rds_password.version_id
}

output "api_env_vars" {
  value = data.aws_secretsmanager_secret_version.api_env_vars_version.secret_string
}

output "reminder_env_vars" {
  value = data.aws_secretsmanager_secret_version.reminder_env_vars_version.secret_string
}

output "frontend_env_vars" {
  value = data.aws_secretsmanager_secret_version.frontend_env_vars_version.secret_string
}

output "shared_secrets" {
  value = data.aws_secretsmanager_secret_version.shared_secrets_version.secret_string
}

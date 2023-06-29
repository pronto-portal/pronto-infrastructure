data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id  = var.db_secret_id
  version_id = var.db_secret_version_id
}

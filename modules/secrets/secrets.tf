resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "-_.!~*"
}

resource "aws_secretsmanager_secret" "rds_password" {
  name = "rds_password"
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.password.result
}

output "db_secret_id" {
  value = aws_secretsmanager_secret.rds_password.id
}

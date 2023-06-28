resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#%*()-_[]{}<>"
}

resource "aws_kms_key" "master_user_kms_key" {
  description = "KMS Key for rds master user"
}

resource "aws_secretsmanager_secret" "db_password" {
  name       = "db_password"
  kms_key_id = aws_kms_key.master_user_kms_key.id
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.password.result
}

resource "aws_db_subnet_group" "pronto_rds_subnet_group" {
  name       = "pronto_rds_subnet_group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_rds_cluster" "pronto_rds_cluster" {
  cluster_identifier            = "pronto-postgres"
  engine                        = "aurora-postgresql"
  db_subnet_group_name          = aws_db_subnet_group.pronto_rds_subnet_group.name
  engine_mode                   = "provisioned"
  engine_version                = "14.6"
  database_name                 = "pronto"
  master_username               = "master_user"
  master_password               = aws_secretsmanager_secret_version.db_password.secret_string
  master_user_secret_kms_key_id = aws_kms_key.master_user_kms_key.key_id

  vpc_security_group_ids = [aws_security_group.rds_allow_ecs_ingress.id]

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "pronto_db_instance" {
  cluster_identifier = aws_rds_cluster.pronto_rds_cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.pronto_rds_cluster.engine
  engine_version     = aws_rds_cluster.pronto_rds_cluster.engine_version
}

output "DATABASE_URL" {
  value     = "postgres://${aws_rds_cluster.pronto_rds_cluster.master_username}:${aws_secretsmanager_secret_version.db_password.secret_string}@${aws_rds_cluster.pronto_rds_cluster.endpoint}:${aws_rds_cluster.pronto_rds_cluster.port}/${aws_rds_cluster.pronto_rds_cluster.database_name}"
  sensitive = true
}

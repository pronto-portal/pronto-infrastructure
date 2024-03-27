resource "aws_db_subnet_group" "pronto_rds_subnet_group" {
  name       = "pronto_rds_subnet_group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_rds_cluster" "pronto_rds_cluster" {
  cluster_identifier   = "pronto-postgres"
  engine               = "aurora-postgresql"
  db_subnet_group_name = aws_db_subnet_group.pronto_rds_subnet_group.name
  engine_mode          = "provisioned"
  engine_version       = "14.6"
  database_name        = "pronto"
  master_username      = "master_user"
  master_password      = data.aws_secretsmanager_secret_version.rds_password.secret_string
  skip_final_snapshot  = true

  vpc_security_group_ids = [
    aws_security_group.rds_allow_ecs_ingress.id,
  aws_security_group.rds_allow_bastion_connectivity.id]

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

// bastion to connect to rds
resource "aws_instance" "rds_bastion" {
  ami                         = "ami-0c101f26f147fa7fd"
  instance_type               = "t2.micro"
  key_name                    = "dev"
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y postgresql-client",
      "psql -h pronto-postgres.cluster-ro-cpydu0kwrf24.us-east-1.rds.amazonaws.com -U master_user -d pronto"
    ]
  }
}

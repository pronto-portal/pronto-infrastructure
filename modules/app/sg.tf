resource "aws_security_group" "pronto_api_vpc_link_sg" {
  name        = "pronto-api-vpc-link-sg"
  description = "Security Group for API Gateway VPC Link"
  vpc_id      = var.vpc_id // your VPC ID

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/26"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_allow_inbound_nlb" {
  name        = "ecs_allow_inbound_nlb"
  description = "Security Group for API Gateway VPC Link"
  vpc_id      = var.vpc_id // your VPC ID

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/26"]
  }
}


resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_allow_inbound_alb_ui" {
  name        = "ecs_allow_inbound_alb_ui"
  description = "Security Group for API Gateway VPC Link"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
}

resource "aws_security_group" "ecs_allow_rds_ingress" {
  name        = "ecs_allow_rds_ingress"
  description = "Security Group for allowing RDS Traffic"
  vpc_id      = var.vpc_id // your VPC ID

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/26"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/26"]
  }
}

resource "aws_security_group" "rds_allow_ecs_ingress" {
  name        = "rds_allow_ecs_ingress"
  description = "Security Group for allowing ECS traffic from port 4000"
  vpc_id      = var.vpc_id // your VPC ID

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


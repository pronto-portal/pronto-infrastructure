resource "aws_security_group" "pronto_api_vpc_link_sg" {
  name        = "pronto-api-vpc-link-sg"
  description = "Security Group for API Gateway VPC Link"
  vpc_id      = var.vpc_id // your VPC ID

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

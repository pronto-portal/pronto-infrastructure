resource "aws_security_group" "allow_all_egress" {
  name        = "allow_all_egress"
  description = "Allow outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    App = "pronto"
  }
}

output "allow_all_egress" {
  value = aws_security_group.allow_all_egress.id
}
resource "aws_vpc" "pronto" {
  cidr_block = "10.0.0.0/26"
  enable_dns_hostnames=true

  tags = {
    Name ="pronto-vpc"
    App = "pronto"
  }
}

output "pronto_vpc_id" {
  value = aws_vpc.pronto.id
}
resource "aws_vpc" "pronto" {
  cidr_block = "10.0.0.0/27"
  enable_dns_hostnames=true

  tags = {
    Name ="pronto-vpc"
    App = "pronto"
  }
}
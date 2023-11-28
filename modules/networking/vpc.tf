resource "aws_vpc" "pronto" {
  cidr_block           = "10.0.0.0/25"
  enable_dns_hostnames = true

  tags = {
    Name = "pronto-vpc"
    App  = "pronto"
  }
}

resource "aws_subnet" "pronto_private_subnet" {
  vpc_id     = aws_vpc.pronto.id
  cidr_block = "10.0.0.0/28"
  map_public_ip_on_launch = false

  tags = {
    Name = "pronto-private-subnet"
    App = "pronto"
  }
}

resource "aws_subnet" "pronto_public_subnet" {
  vpc_id     = aws_vpc.pronto.id
  cidr_block = "10.0.0.64/28"
  map_public_ip_on_launch = true

  tags = {
    Name = "pronto-public-subnet"
    App = "pronto"
  }
}
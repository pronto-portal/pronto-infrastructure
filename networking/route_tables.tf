resource "aws_route_table" "pronto_public_route_table" {
  vpc_id = aws_vpc.pronto.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pronto.id
  }

  tags = {
    Name = "pronto-private-public-table"
    App = "pronto"
  }
}

resource "aws_route_table" "pronto_private_route_table" {
  vpc_id = aws_vpc.pronto.id

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.pronto_nat_gateway.id
    }
  tags = {
    Name = "pronto-private-route-table"
    App = "pronto"
  }
}
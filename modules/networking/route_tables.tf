resource "aws_route_table" "pronto_public_route_table" {
  vpc_id = aws_vpc.pronto.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pronto_internet_gateway.id
  }

  tags = {
    App  = "pronto"
    Name = "public"
  }
}

resource "aws_route_table" "pronto_private_route_table_az_a" {
  vpc_id = aws_vpc.pronto.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pronto_nat_gateway_az_a.id
  }
  tags = {
    App  = "pronto"
    Name = "private_az_a"
  }
}

resource "aws_route_table" "pronto_private_route_table_az_b" {
  vpc_id = aws_vpc.pronto.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pronto_nat_gateway_az_b.id
  }
  tags = {
    App  = "pronto"
    Name = "private_az_b"
  }
}

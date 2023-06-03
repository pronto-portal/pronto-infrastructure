resource "aws_nat_gateway" "pronto_nat_gateway_az_a"{
  allocation_id = aws_eip.pronto_eip_az_a.id
  subnet_id = aws_subnet.pronto_public_az_a.id

  tags = {
    App = "pronto"
  }
}

resource "aws_nat_gateway" "pronto_nat_gateway_az_b"{
  allocation_id = aws_eip.pronto_eip_az_b.id
  subnet_id = aws_subnet.pronto_public_az_b.id

  tags = {
    App = "pronto"
  }
}
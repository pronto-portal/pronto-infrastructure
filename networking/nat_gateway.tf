resource "aws_nat_gateway" "pronto_nat_gateway"{
  allocation_id = aws_eip.pronto.id
  subnet_id = aws_subnet.pronto_public_subnet.id

  tags = {
    Name = "pronto_nat_gateway"
    App = "pronto"
  }
}
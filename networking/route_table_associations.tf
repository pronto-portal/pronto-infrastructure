resource "aws_route_table_association" "pronto_private_subnet_association_az_a" {
  subnet_id      = aws_subnet.pronto_private_az_a.id
  route_table_id = aws_route_table.pronto_private_route_table_az_a.id
}

resource "aws_route_table_association" "pronto_private_subnet_association_az_b" {
  subnet_id      = aws_subnet.pronto_private_az_b.id
  route_table_id = aws_route_table.pronto_private_route_table_az_b.id
}

resource "aws_route_table_association" "pronto_public_association_az_a" {
  subnet_id      = aws_subnet.pronto_public_az_a.id
  route_table_id = aws_route_table.pronto_public_route_table.id
}

resource "aws_route_table_association" "pronto_public_association_az_b" {
  subnet_id      = aws_subnet.pronto_public_az_b.id
  route_table_id = aws_route_table.pronto_public_route_table.id
}
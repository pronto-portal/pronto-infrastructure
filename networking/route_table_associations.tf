resource "aws_route_table_association" "pronto_private_subnet_association" {
  subnet_id      = aws_subnet.pronto_private_subnet.id
  route_table_id = aws_route_table.pronto_private_route_table.id
}


resource "aws_route_table_association" "pronto_public_association" {
  subnet_id      = aws_subnet.pronto_public_subnet.id
  route_table_id = aws_route_table.pronto_public_route_table.id
}
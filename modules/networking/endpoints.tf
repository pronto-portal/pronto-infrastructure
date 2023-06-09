resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.pronto.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.pronto_private_route_table_az_a.id,
    aws_route_table.pronto_private_route_table_az_b.id,
  ]
}

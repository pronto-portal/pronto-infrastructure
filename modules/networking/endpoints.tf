resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.pronto.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.pronto_private_route_table_az_a.id,
    aws_route_table.pronto_private_route_table_az_b.id,
  ]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.pronto.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subnet_ids

  tags = {
    Name = "ec2messages-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.pronto.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subnet_ids

  tags = {
    Name = "ssm-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.pronto.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subnet_ids

  tags = {
    Name = "ssmmessages-vpc-endpoint"
  }
}

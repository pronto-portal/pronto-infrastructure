resource "aws_subnet" "pronto_private_az_a" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    App  = "pronto"
    Name = "private_az_a"
  }
}

resource "aws_subnet" "pronto_private_az_b" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.16/28"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    App  = "pronto"
    Name = "private_az_b"
  }
}

resource "aws_subnet" "pronto_public_az_a" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.32/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    App  = "pronto"
    Name = "public_az_a"
  }
}

resource "aws_subnet" "pronto_public_az_b" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.48/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    App  = "pronto"
    Name = "public_az_b"
  }
}

output "pronto_private_az_a" {
  value = aws_subnet.pronto_private_az_a.id
}

output "pronto_private_az_b" {
  value = aws_subnet.pronto_private_az_b.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.pronto_private_az_a.id,
    aws_subnet.pronto_private_az_b.id
  ]
}

output "private_subnet_arns" {
  value = [
    aws_subnet.pronto_private_az_a.arn,
    aws_subnet.pronto_private_az_b.arn
  ]
}

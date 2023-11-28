resource "aws_subnet" "pronto_private_az_a" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.0/27"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    App  = "pronto"
    Name = "private_az_a"
  }
}

resource "aws_subnet" "pronto_private_az_b" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.32/27"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    App  = "pronto"
    Name = "private_az_b"
  }
}

resource "aws_subnet" "pronto_public_az_a" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.64/27"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    App  = "pronto"
    Name = "public_az_a"
  }
}

resource "aws_subnet" "pronto_public_az_b" {
  vpc_id                  = aws_vpc.pronto.id
  cidr_block              = "10.0.0.96/27"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    App  = "pronto"
    Name = "public_az_b"
  }
}

resource "aws_subnet" "pronto_private_az_a" {
  vpc_id     = aws_vpc.pronto.id
  cidr_block = "10.0.0.0/28"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"

  tags = {
    App = "pronto"
  }
}

resource "aws_subnet" "pronto_private_az_b" {
  vpc_id     = aws_vpc.pronto.id
  cidr_block = "10.0.0.16/28"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"

  tags = {
    App = "pronto"
  }
}

resource "aws_subnet" "pronto_public_az_a" {
  vpc_id     = aws_vpc.pronto.id
  cidr_block = "10.0.0.32/28"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    App = "pronto"
  }
}

resource "aws_subnet" "pronto_public_az_b" {
  vpc_id     = aws_vpc.pronto.id
  cidr_block = "10.0.0.48/28"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    App = "pronto"
  }
}
resource "aws_internet_gateway" "pronto" {
  vpc_id = aws_vpc.pronto.id

  tags = {
    Name = "pronto-gateway"
  }
}
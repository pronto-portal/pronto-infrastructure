resource "aws_internet_gateway" "pronto_internet_gateway" {
  vpc_id = aws_vpc.pronto.id

  tags = {
    App = "pronto"
  }
}
resource "aws_eip" "pronto_eip_az_a" {
  depends_on = [ aws_internet_gateway.pronto_internet_gateway ]
  tags = {
    App = "pronto"
  }
}

resource "aws_eip" "pronto_eip_az_b" {
  depends_on = [ aws_internet_gateway.pronto_internet_gateway ]
  tags = {
    App = "pronto"
  }
}
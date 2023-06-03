resource "aws_eip" "pronto" {
  vpc = true

  depends_on = [ aws_internet_gateway.pronto ]
  tags = {
    Name = "pronto-eip"
  }
}
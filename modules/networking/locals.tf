locals {
  private_subnet_ids = [
    aws_subnet.pronto_private_az_b.id,
    aws_subnet.pronto_private_az_a.id
  ]
}

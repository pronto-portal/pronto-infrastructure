
output "pronto_vpc_id" {
  value = aws_vpc.pronto.id
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

output "pronto_public_az_a" {
  value = aws_subnet.pronto_public_az_a.id
}

output "pronto_public_az_b" {
  value = aws_subnet.pronto_public_az_b.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.pronto_public_az_a.id,
    aws_subnet.pronto_public_az_b.id
  ]
}

output "public_subnet_arns" {
  value = [
    aws_subnet.pronto_public_az_a.arn,
    aws_subnet.pronto_public_az_b.arn
  ]
}

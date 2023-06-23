resource "aws_ecr_repository" "pronto_ecr" {
  name                 = "pronto-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "arn" {
    value = aws_ecr_repository.pronto_ecr.arn
}

output "id" {
    value = aws_ecr_repository.pronto_ecr.id
}

output "repository_url" {
    value = aws_ecr_repository.pronto_ecr.repository_url
}

output "tags_all"{
    value = aws_ecr_repository.pronto_ecr.tags_all
}
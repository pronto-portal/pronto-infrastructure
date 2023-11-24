output "backend_arn" {
  value = aws_ecr_repository.pronto_backend_ecr.arn
}

output "backend_id" {
  value = aws_ecr_repository.pronto_backend_ecr.id
}

output "backend_repository_url" {
  value = aws_ecr_repository.pronto_backend_ecr.repository_url
}

output "backend_tags_all" {
  value = aws_ecr_repository.pronto_backend_ecr.tags_all
}


output "frontend_arn" {
  value = aws_ecr_repository.pronto_frontend_ecr.arn
}

output "frontend_id" {
  value = aws_ecr_repository.pronto_frontend_ecr.id
}

output "frontend_repository_url" {
  value = aws_ecr_repository.pronto_frontend_ecr.repository_url
}

output "frontend_tags_all" {
  value = aws_ecr_repository.pronto_frontend_ecr.tags_all
}

output "ecr_image_pull_policy_arn" {
  value = aws_iam_policy.ecr_image_pull.arn
}


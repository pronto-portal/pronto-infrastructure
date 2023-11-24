resource "aws_ecr_repository" "pronto_backend_ecr" {
  name                 = "pronto-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "pronto_frontend_ecr" {
  name                 = "pronto-ui-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

}



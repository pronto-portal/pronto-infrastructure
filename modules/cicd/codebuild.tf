resource "aws_codebuild_project" "pronto_backend" {
  name          = "pronto_backend"
  description   = "ci for pronto backend"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.pronto_artifacts.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "pronto_backend_codebuild"
      stream_name = "pronto"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/pronto-portal/pronto-api.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  vpc_config {
    vpc_id = aws_vpc.pronto.id

    subnets = [
      aws_subnet.pronto_private_az_a.id
      aws_subnet.pronto_private_az_b.id,
    ]

    security_group_ids = []
  }

  tags = {
    App = "pronto"
  }
}
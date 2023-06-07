terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

resource "aws_codebuild_source_credential" "pronto_api_access_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_access_token
}

resource "aws_codebuild_project" "pronto_codebuild" {
  name          = "pronto_codebuild"
  description   = "ci for pronto api"
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
    buildspec = "buildspec.yml" 

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.private_subnet_ids
    security_group_ids = [var.allow_all_egress_id]
  }

  tags = {
    App = "pronto"
  }
}

resource "aws_codebuild_webhook" "pronto_codebuild_webhook" {
  project_name = aws_codebuild_project.pronto_codebuild.name
  build_type = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH,PULL_REQUEST_MERGED"
    }
  }
}
resource "aws_codebuild_source_credential" "pronto_reminder_access_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_access_token
}

resource "aws_codebuild_project" "pronto_reminder_codebuild" {
  name          = "pronto_reminder_codebuild"
  description   = "ci for pronto reminder lambda"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_backend_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
    name = null
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }

    environment_variable {
      name  = "REMINDER_FUNCTION_ARN"
      value = var.pronto_api_reminder_function_arn
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "pronto_backend_codebuild"
      stream_name = "pronto"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/pronto-portal/pronto_reminder.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = [var.allow_all_egress_id]
  }

  tags = {
    App = "pronto"
  }
}

resource "aws_codebuild_webhook" "pronto_reminder_codebuild_webhook" {
  project_name = aws_codebuild_project.pronto_reminder_codebuild.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_MERGED"
    }

    filter {
      type    = "BASE_REF"
      pattern = "refs/heads/master"
    }
  }
}

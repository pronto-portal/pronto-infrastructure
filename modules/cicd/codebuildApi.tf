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
    type = "NO_ARTIFACTS"
    name = null
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.pronto_ecr_repo_url
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }

    environment_variable {
      name  = "DATABASE_URL"
      value = var.DATABASE_URL
    }

    environment_variable {
      name  = "CONTAINER_DEFINITIONS"
      value = var.container_definitions
    }

    environment_variable {
      name  = "ECS_SERVICE_ID"
      value = var.ecs_service_id
    }

    environment_variable {
      name  = "ECS_TASK_DEFINITION_ARN"
      value = var.ecs_task_definition_arn
    }

    environment_variable {
      name  = "ECS_CLUSTER_ARN"
      value = var.ecs_cluster_arn
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
    location        = "https://github.com/pronto-portal/pronto-api.git"
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

resource "aws_codebuild_webhook" "pronto_codebuild_webhook" {
  project_name = aws_codebuild_project.pronto_codebuild.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH,PULL_REQUEST_MERGED"
    }
  }
}

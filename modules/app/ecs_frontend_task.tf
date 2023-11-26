locals {
  frontend_decoded_container_definitions = [
    {
      "name" : "ui",
      "image" : "${var.pronto_frontend_ecr_repo_url}:latest",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 3000
          "appProtocol" : "http",
          "hostPort" : 3000,
        }
      ],
      "memory" : 1024,
      "cpu" : 512,
      "environment" : [
        {
          name : "NEXT_PUBLIC_API_URL",
          value : "https://${aws_apigatewayv2_api.pronto_api.api_endpoint}"
        },
        {
          name : "NEXTAUTH_SECRET",
          value : local.frontend_env_secret["NEXTAUTH_SECRET"]
        },
        {
          name : "NEXTAUTH_URL",
          value : data.aws_acm_certificate.pronto_issued_certificate.domain
        },
        {
          name : "GOOGLE_CLIENT_ID",
          value : local.GOOGLE_CLIENT_ID
        },
        {
          name : "GOOGLE_CLIENT_SECRET_ID",
          value : local.GOOGLE_CLIENT_SECRET_ID
        },
        {
          name : "NEXT_PUBLIC_GOOGLE_PLACES_API_KEY",
          value : local.GOOGLE_PLACES_API_KEY
        },
        {
          name : "NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY",
          value : local.frontend_env_secret["NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY"]
        }
      ],
      "healthCheck" : {
        "command" : ["CMD-SHELL", "curl", "-f", "http://localhost:3000", "||", "exit", "1"],
        "interval" : 30,
        "timeout" : 20,
        "retries" : 3,
        "startPeriod" : 240
      },
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.pronto_ecs.name}",
          "awslogs-region" : data.aws_region.current.name,
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ]

  frontend_container_definitions = jsonencode(local.frontend_decoded_container_definitions)
  task_definition_frontend = jsonencode({
    "family" : aws_ecs_task_definition.pronto-ui-task.family,
    "networkMode" : aws_ecs_task_definition.pronto-ui-task.network_mode,
    "requiresCompatibilities" : local.requires_compatibilities,
    "memory" : aws_ecs_task_definition.pronto-ui-task.memory,
    "cpu" : aws_ecs_task_definition.pronto-ui-task.cpu,
    "executionRoleArn" : aws_ecs_task_definition.pronto-ui-task.execution_role_arn,
    "containerDefinitions" : local.frontend_decoded_container_definitions,
    "runtimePlatform" : local.runtime_platform
  })
}

resource "aws_ecs_task_definition" "pronto-ui-task" {
  family                   = "pronto-ui"
  network_mode             = "awsvpc"
  requires_compatibilities = local.requires_compatibilities // Use "FARGATE" for Fargate type
  memory                   = 1024
  cpu                      = 512

  execution_role_arn    = aws_iam_role.pronto_ecs_task_execution.arn
  container_definitions = local.frontend_container_definitions

  runtime_platform {
    operating_system_family = local.operating_system_family // "LINUX"
    cpu_architecture        = local.cpu_architecture        // "X86_64"
  }
}

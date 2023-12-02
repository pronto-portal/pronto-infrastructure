locals {
  backend_decoded_container_definitions = [
    {
      "name" : "api",
      "image" : "${var.pronto_backend_ecr_repo_url}:latest",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 4000,
          "appProtocol" : "http",
          "hostPort" : 4000,
        }
      ],
      "memory" : 1024,
      "cpu" : 512,
      "environment" : [
        {
          "name" : "DATABASE_URL",
          "value" : "postgres://${aws_rds_cluster.pronto_rds_cluster.master_username}:${data.aws_secretsmanager_secret_version.rds_password.secret_string}@${aws_rds_cluster.pronto_rds_cluster.endpoint}:${aws_rds_cluster.pronto_rds_cluster.port}/${aws_rds_cluster.pronto_rds_cluster.database_name}"
        },
        {
          "name" : "GOOGLE_CLIENT_ID",
          "value" : local.GOOGLE_CLIENT_ID
        },
        {
          "name" : "GOOGLE_CLIENT_SECRET_ID",
          "value" : local.GOOGLE_CLIENT_SECRET_ID
        },
        {
          "name" : "GOOGLE_TRANSLATE_API_KEY",
          "value" : local.GOOGLE_TRANSLATE_API_KEY
        },
        {
          "name" : "JWT_SECRET",
          "value" : local.api_env_secret["JWT_SECRET"]
        },
        {
          "name" : "REFRESH_SECRET",
          "value" : local.api_env_secret["REFRESH_SECRET"]
        },
        {
          "name" : "TOKEN_ENCRYPT_SECRET",
          "value" : local.api_env_secret["TOKEN_ENCRYPT_SECRET"]
        },
        {
          "name" : "REMINDER_FUNCTION_ARN",
          "value" : aws_lambda_function.pronto_api_reminder.arn
        },
        {
          "name" : "ECS_TASK_EXECUTION_ROLE_ARN",
          "value" : aws_iam_role.pronto_ecs_task_execution.arn
        },
        {
          "name" : "EVENT_RULE_ROLE_ARN",
          "value" : aws_iam_role.pronto_event_rule_role.arn
        },
        {
          "name" : "LOAD_BALANCER_DNS",
          "value" : aws_lb.pronto_api_alb.dns_name
        },
        {
          "name" : "ALB_DNS",
          "value" : aws_lb.pronto_ui_alb.dns_name
        },
        {
          "name" : "API_GATEWAY_DNS",
          "value" : aws_apigatewayv2_api.pronto_api.api_endpoint
        },
        {
          "name" : "AWS_ACCESS_KEY_ID",
          "value" : aws_iam_access_key.pronto_ecs_task_worker_key.id
        },
        {
          "name" : "AWS_SECRET_ACCESS_KEY",
          "value" : aws_iam_access_key.pronto_ecs_task_worker_key.secret
        },
        {
          "name" : "AWS_DEFAULT_REGION",
          "value" : data.aws_region.current.name
        },
        {
          "name" : "STRIPE_PUBLISH_KEY",
          "value" : local.api_env_secret["STRIPE_PUBLISH_KEY"]
        },
        {
          "name" : "STRIPE_SECRET_KEY",
          "value" : local.api_env_secret["STRIPE_SECRET_KEY"]
        },
        {
          "name" : "STRIPE_WEBHOOK_SECRET",
          "value" : local.api_env_secret["STRIPE_WEBHOOK_SECRET"]
        },
        {
          "name" : "GOOGLE_TRANSLATE_API_KEY",
          "value" : local.api_env_secret["GOOGLE_TRANSLATE_API_KEY"]
        }
      ],
      "healthCheck" : {
        "command" : ["CMD-SHELL", "curl -s --fail http://localhost:4000 || exit 1"],
        "interval" : 30,
        "timeout" : 20,
        "retries" : 3,
        "startPeriod" : 60
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

  backend_container_definitions = jsonencode(local.backend_decoded_container_definitions)

  task_definition_api = jsonencode({
    "family" : aws_ecs_task_definition.pronto-api-task.family,
    "networkMode" : aws_ecs_task_definition.pronto-api-task.network_mode,
    "requiresCompatibilities" : local.requires_compatibilities,
    "memory" : aws_ecs_task_definition.pronto-api-task.memory,
    "cpu" : aws_ecs_task_definition.pronto-api-task.cpu,
    "executionRoleArn" : aws_ecs_task_definition.pronto-api-task.execution_role_arn,
    "taskRoleArn" : local.task_role_arn,
    "containerDefinitions" : local.backend_decoded_container_definitions,
    "runtimePlatform" : local.runtime_platform
  })
}

resource "aws_ecs_task_definition" "pronto-api-task" {
  family                   = "pronto-api"
  network_mode             = "awsvpc"
  requires_compatibilities = local.requires_compatibilities // Use "FARGATE" for Fargate type
  task_role_arn            = local.task_role_arn
  memory                   = 1024
  cpu                      = 512
  execution_role_arn       = aws_iam_role.pronto_ecs_task_execution.arn
  container_definitions    = local.backend_container_definitions

  runtime_platform {
    operating_system_family = local.operating_system_family // "LINUX"
    cpu_architecture        = local.cpu_architecture        // "X86_64"
  }
}

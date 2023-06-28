resource "aws_kms_key" "pronto-ecs-kms" {
  description             = "ECS KMS Key for Pronto API"
  deletion_window_in_days = 7
}

resource "aws_ecs_cluster" "pronto-cluster" {
  name = "pronto-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.pronto-ecs-kms.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.pronto_ecs.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "pronto-api-task" {
  family                   = "pronto-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"] // Use "FARGATE" for Fargate type
  memory                   = 512
  cpu                      = 256

  execution_role_arn = aws_iam_role.pronto_ecs_task_execution.arn

  container_definitions = jsonencode(
    [
      {
        "name" : "api",
        "image" : "${var.pronto_ecr_repo_url}:latest",
        "essential" : true,
        "portMappings" : [
          {
            "containerPort" : 4000
          }
        ],
        "memory" : 512,
        "cpu" : 256,
        "environment" : [
          {
            "name" : "DATABASE_URL",
            "value" : "postgres://${aws_rds_cluster.pronto_rds_cluster.master_username}:${random_password.password.result}@${aws_rds_cluster.pronto_rds_cluster.endpoint}:${aws_rds_cluster.pronto_rds_cluster.port}/${aws_rds_cluster.pronto_rds_cluster.database_name}"
          },
          {
            "name" : "GOOGLE_CLIENT_ID",
            "value" : var.GOOGLE_CLIENT_ID
          },
          {
            "name" : "GOOGLE_CLIENT_SECRET_ID",
            "value" : var.GOOGLE_CLIENT_SECRET_ID
          },
          {
            "name" : "JWT_SECRET",
            "value" : var.JWT_SECRET
          },
          {
            "name" : "REFRESH_SECRET",
            "value" : var.REFRESH_SECRET
          },
          {
            "name" : "TOKEN_ENCRYPT_SECRET",
            "value" : var.TOKEN_ENCRYPT_SECRET
          },
          {
            "name" : "REMINDER_FUNCTION_ARN",
            "value" : aws_lambda_function.pronto_api_reminder.arn
          },
          {
            "name" : "ECS_TASK_EXECUTION_ROLE_ARN",
            "value" : aws_iam_role.pronto_ecs_task_execution.arn
          }
        ]
      }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "pronto_api_service" {
  name                 = "pronto_api_service"
  cluster              = aws_ecs_cluster.pronto-cluster.arn // e.g. "arn:aws:ecs:us-east-1:123456789012:cluster/my_cluster"
  task_definition      = aws_ecs_task_definition.pronto-api-task.arn
  desired_count        = 1
  force_new_deployment = true
  launch_type          = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.pronto_api_nlb_target_group.arn
    container_name   = "api"
    container_port   = 4000
  }

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [
      var.allow_all_egress_id,
      aws_security_group.ecs_allow_inbound_nlb.id,
    aws_security_group.ecs_allow_rds_ingress.id]
    assign_public_ip = false
  }
}

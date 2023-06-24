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
  requires_compatibilities = ["EC2"] // Use "FARGATE" for Fargate type

  container_definitions = jsonencode(
    [
      {
        "name" : "api",
        "image" : "${var.pronto_ecr_repo_url}:latest",
        "essential" : true,
        "portMappings" : [
          {
            "containerPort" : 4000,
            "hostPort" : 4000
          }
        ],
        "memory" : 500,
        "cpu" : 256
      }
  ])

}

resource "aws_ecs_service" "pronto_api_service" {
  name                 = "pronto_api_service"
  cluster              = aws_ecs_cluster.pronto-cluster.arn // e.g. "arn:aws:ecs:us-east-1:123456789012:cluster/my_cluster"
  task_definition      = aws_ecs_task_definition.pronto-api-task.arn
  desired_count        = 1
  force_new_deployment = true
  launch_type          = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.pronto_api_nlb_target_group.arn
    container_name   = "api"
    container_port   = 4000
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.allow_all_egress_id]
    assign_public_ip = false
  }
}

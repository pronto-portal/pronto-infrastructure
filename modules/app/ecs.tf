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
  requires_compatibilities = local.requires_compatibilities // Use "FARGATE" for Fargate type
  memory                   = 512
  cpu                      = 256

  execution_role_arn    = aws_iam_role.pronto_ecs_task_execution.arn
  container_definitions = local.backend_container_definitions

  runtime_platform {
    operating_system_family = local.operating_system_family // "LINUX"
    cpu_architecture        = local.cpu_architecture        // "X86_64"
  }
}

resource "aws_ecs_service" "pronto_api_service" {
  name                               = "pronto_api_service"
  cluster                            = aws_ecs_cluster.pronto-cluster.arn // e.g. "arn:aws:ecs:us-east-1:123456789012:cluster/my_cluster"
  task_definition                    = aws_ecs_task_definition.pronto-api-task.arn
  desired_count                      = 1
  force_new_deployment               = true
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

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

resource "aws_ecs_task_definition" "pronto-ui-task" {
  family                   = "pronto-ui"
  network_mode             = "awsvpc"
  requires_compatibilities = local.requires_compatibilities // Use "FARGATE" for Fargate type
  memory                   = 512
  cpu                      = 256

  execution_role_arn    = aws_iam_role.pronto_ecs_task_execution.arn
  container_definitions = local.frontend_container_definitions

  runtime_platform {
    operating_system_family = local.operating_system_family // "LINUX"
    cpu_architecture        = local.cpu_architecture        // "X86_64"
  }
}

resource "aws_ecs_service" "pronto_ui_service" {
  name                               = "pronto_ui_service"
  cluster                            = aws_ecs_cluster.pronto-cluster.arn
  task_definition                    = aws_ecs_task_definition.pronto-ui-task.arn
  desired_count                      = 1
  force_new_deployment               = true
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  load_balancer {
    target_group_arn = aws_lb_target_group.pronto_ui_alb_target_group.arn // create alb
    container_name   = "ui"
    container_port   = 3000
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

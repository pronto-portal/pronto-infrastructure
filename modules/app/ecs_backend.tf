resource "aws_ecs_service" "pronto_api_service" {
  name                 = "pronto_api_service"
  cluster              = aws_ecs_cluster.pronto-cluster.arn // e.g. "arn:aws:ecs:us-east-1:123456789012:cluster/my_cluster"
  task_definition      = aws_ecs_task_definition.pronto-api-task.arn
  desired_count        = 1
  force_new_deployment = false
  launch_type          = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.pronto_api_alb_target_group.arn
    container_name   = "api"
    container_port   = 4000
  }

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [
      aws_security_group.api_ecs_service_sg.id
    ]
    assign_public_ip = false
  }
}


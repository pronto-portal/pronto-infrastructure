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
    target_group_arn = aws_lb_target_group.pronto_api_alb_target_group.arn
    container_name   = "api"
    container_port   = 4000
  }

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [
      var.allow_all_egress_id,
      aws_security_group.ecs_allow_inbound_alb.id,
    aws_security_group.ecs_allow_rds_ingress.id]
    assign_public_ip = false
  }
}


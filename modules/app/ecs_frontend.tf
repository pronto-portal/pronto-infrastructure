resource "aws_ecs_service" "pronto_ui_service" {
  name                 = "pronto_ui_service"
  cluster              = aws_ecs_cluster.pronto-cluster.arn
  task_definition      = aws_ecs_task_definition.pronto-ui-task.arn
  desired_count        = 1
  force_new_deployment = true
  launch_type          = "FARGATE"
  # deployment_maximum_percent         = 200
  # deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.pronto_ui_alb_target_group.arn
    container_name   = "ui"
    container_port   = 3000
  }

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [
      var.allow_all_egress_id,
    aws_security_group.ecs_allow_inbound_alb_ui.id]
    assign_public_ip = false
  }
}


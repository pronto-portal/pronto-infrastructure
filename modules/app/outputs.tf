output "ecs_cluster_arn" {
  value = aws_ecs_cluster.pronto-cluster.arn
}

output "ecs_service_api_id" {
  value = aws_ecs_service.pronto_api_service.id
}

output "ecs_task_definition_api_arn" {
  value = aws_ecs_task_definition.pronto-api-task.arn
}

output "ecs_service_frontend_id" {
  value = aws_ecs_service.pronto_ui_service.id
}

output "ecs_task_definition_frontend_arn" {
  value = aws_ecs_task_definition.pronto-ui-task.arn
}

output "pronto_event_rule_invoke_reminder_function_arn" {
  value = aws_iam_role.pronto_event_rule_role.arn
}

output "pronto_ecs_task_execution_arn" {
  value = aws_iam_role.pronto_ecs_task_execution.arn
}

output "pronto_api_reminder_function_arn" {
  value = aws_lambda_function.pronto_api_reminder.arn
}


output "DATABASE_URL" {
  value     = "postgres://${aws_rds_cluster.pronto_rds_cluster.master_username}:${data.aws_secretsmanager_secret_version.rds_password.secret_string}@${aws_rds_cluster.pronto_rds_cluster.endpoint}:${aws_rds_cluster.pronto_rds_cluster.port}/${aws_rds_cluster.pronto_rds_cluster.database_name}"
  sensitive = true
}

output "container_definitions_backend" {
  value = local.backend_container_definitions
}

output "container_definitions_frontend" {
  value = local.frontend_container_definitions
}

output "task_definition_backend" {
  value = local.task_definition_api
}

output "task_definition_frontend" {
  value = local.task_definition_frontend
}

output "api_gateway_url" {
  value = "https://${data.aws_acm_certificate.pronto_api_issued_certificate.domain}"
}

output "ecs_task_exec_role_arn" {
  value = aws_iam_role.ecs_task_exec_role.arn
}

output "ui_alb_url" {
  value = local.ui_alb_url
}

output "ui_domain_name" {
  value = data.aws_acm_certificate.pronto_issued_certificate.domain
}

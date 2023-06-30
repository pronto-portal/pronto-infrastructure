variable "private_subnet_ids" {}
variable "allow_all_egress_id" {}
variable "vpc_id" {}
variable "db_secret_id" {}
variable "db_secret_version_id" {}

variable "GOOGLE_CLIENT_ID" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "GOOGLE_CLIENT_SECRET_ID" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "JWT_SECRET" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "REFRESH_SECRET" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "TOKEN_ENCRYPT_SECRET" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "vpc_access_policy_arn" {}
variable "cloudwatch_logging_arn" {}
variable "pronto_ecr_repo_url" {}
variable "ecr_image_pull_policy_arn" {}

variable "api_gateway_stage" {
  type    = string
  default = "dev"
}

locals {
  decoded_container_definitions = [
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
          "value" : "postgres://${aws_rds_cluster.pronto_rds_cluster.master_username}:${data.aws_secretsmanager_secret_version.rds_password.secret_string}@${aws_rds_cluster.pronto_rds_cluster.endpoint}:${aws_rds_cluster.pronto_rds_cluster.port}/${aws_rds_cluster.pronto_rds_cluster.database_name}"
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
        },
        {
          "name" : "EVENT_RULE_ROLE_ARN",
          "value" : aws_iam_role.pronto_event_rule_role.arn
        }
      ],
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

  container_definitions = jsonencode(local.decoded_container_definitions)

  task_definition = jsonencode({
    "family" : aws_ecs_task_definition.pronto-api-task.family,
    "networkMode" : aws_ecs_task_definition.pronto-api-task.network_mode,
    "requiresCompatibilities" : aws_ecs_task_definition.pronto-api-task.requires_compatibilities,
    "memory" : aws_ecs_task_definition.pronto-api-task.memory,
    "cpu" : aws_ecs_task_definition.pronto-api-task.cpu,
    "executionRoleArn" : aws_ecs_task_definition.pronto-api-task.execution_role_arn,
    "containerDefinitions" : local.decoded_container_definitions,
    "runtimePlatform" : aws_ecs_task_definition.pronto-api-task.runtime_platform
  })
}

output "container_definitions" {
  value = local.container_definitions
}

output "task_definition" {
  value = local.task_definition
}

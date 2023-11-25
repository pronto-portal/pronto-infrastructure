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

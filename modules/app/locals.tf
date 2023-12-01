locals {
  api_env_secret      = jsondecode(var.api_env_vars)
  reminder_env_secret = jsondecode(var.reminder_env_vars)
  frontend_env_secret = jsondecode(var.frontend_env_vars)
  shared_secrets      = jsondecode(var.shared_secrets)

  GOOGLE_CLIENT_ID         = local.shared_secrets["GOOGLE_CLIENT_ID"]
  GOOGLE_CLIENT_SECRET_ID  = local.shared_secrets["GOOGLE_CLIENT_SECRET_ID"]
  GOOGLE_TRANSLATE_API_KEY = local.shared_secrets["GOOGLE_TRANSLATE_API_KEY"]
  GOOGLE_PLACES_API_KEY    = local.shared_secrets["GOOGLE_PLACES_API_KEY"]

  requires_compatibilities = ["FARGATE"]
  operating_system_family  = "LINUX"
  cpu_architecture         = "X86_64"
  task_role_arn            = aws_iam_role.ecs_task_exec_role.arn

  runtime_platform = {
    operatingSystemFamily = local.operating_system_family
    cpuArchitecture       = local.cpu_architecture
  }


}

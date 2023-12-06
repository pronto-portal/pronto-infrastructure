locals {
  frontend_env_secret = jsondecode(var.frontend_env_vars)
  shared_secrets      = jsondecode(var.shared_secrets)


  NEXT_PUBLIC_GOOGLE_TRANSLATE_API_KEY = local.shared_secrets["GOOGLE_TRANSLATE_API_KEY"]
  NEXT_PUBLIC_GOOGLE_PLACES_API_KEY    = local.shared_secrets["GOOGLE_PLACES_API_KEY"]
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY   = local.frontend_env_secret["NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY"]
  NEXT_PRIVATE_API_URL                 = var.api_gateway_url
  NEXT_PUBLIC_API_URL                  = "https://${var.ui_domain_name}/api"
}

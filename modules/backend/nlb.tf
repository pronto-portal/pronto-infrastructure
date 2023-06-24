resource "aws_lb" "pronto_api_nlb" {
  name               = "pronto-api-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "pronto_api_nlb_target_group" {
  name        = "pronto-api-nlb-target-group"
  port        = 4000
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "pronto_api_nlb_listener" {
  load_balancer_arn = aws_lb.pronto_api_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pronto_api_nlb_target_group.arn
  }
}

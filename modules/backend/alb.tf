resource "aws_lb" "pronto_ui_alb" {
  name               = "pronto-ui-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "pronto_ui_alb_target_group" {
  name        = "pronto-ui-alb-target-group"
  port        = 3000
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "pronto_api_alb_listener" {
  load_balancer_arn = aws_lb.pronto_ui_alb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pronto_ui_alb_target_group.arn
  }
}

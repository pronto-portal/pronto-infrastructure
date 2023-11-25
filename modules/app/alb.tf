resource "aws_lb" "pronto_ui_alb" {
  name               = "pronto-ui-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "pronto_ui_alb_target_group" {
  name        = "pronto-ui-alb-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "pronto_ui_alb_listener" {
  load_balancer_arn = aws_lb.pronto_ui_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.pronto_issued_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pronto_ui_alb_target_group.arn
  }
}

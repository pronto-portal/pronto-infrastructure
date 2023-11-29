resource "aws_lb" "pronto_api_alb" {
  name               = "pronto-api-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  security_groups    = [aws_security_group.pronto_api_vpc_link_sg.id, aws_security_group.alb_sg.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "pronto_api_alb_target_group" {
  name        = "pronto-api-alb-target-group"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "pronto_api_alb_listener" {
  load_balancer_arn = aws_lb.pronto_api_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pronto_api_alb_target_group.arn
  }
}

resource "aws_lb" "onl_ors_nlb" {
  name               = "${local.prefix}-nlb-${var.environment}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.aws_app_subnets
  enable_cross_zone_load_balancing = true
#   enable_deletion_protection = true

  tags = merge(
    { Name = "${local.prefix}-nlb-${var.environment}" },
    local.common_tags
  )
}

resource "aws_lb_listener" "onl_ors_nlb_listener" {
  load_balancer_arn = aws_lb.onl_ors_nlb.arn
  port              = "80" # 80 is the default port for HTTP
  protocol          = "TCP"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
#   alpn_policy       = "HTTP2Preferred"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.onl_ors_nlb_tg.arn
  }

  depends_on = [ aws_lb.onl_ors_nlb ]
}

resource "aws_lb_target_group" "onl_ors_nlb_tg" {
  name        = "${local.prefix}-nlb-tg-${var.environment}"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "onl_ors_nlb_attachment" {
  target_group_arn = aws_lb_target_group.onl_ors_nlb_tg.arn
  target_id        = module.alb.lb_arn
  depends_on       = [module.alb]
}

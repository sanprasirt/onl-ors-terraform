resource "aws_lb_listener_rule" "onl_ors_webapp_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 99
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[0]
  }
  condition {
    path_pattern {
      values = ["/ORS2_POS_CLIENT47/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_reserve_rule" {
  #   for_each     = toset(["reserve", "search", "receive", "confirm", "cancel"])
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[1]
  }
  condition {
    path_pattern {
      values = ["/reserve/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_search_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 101
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[2]
  }
  condition {
    path_pattern {
      values = ["/search/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_receive_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 103
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[3]
  }
  condition {
    path_pattern {
      values = ["/receive/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_confirm_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 102
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[4]
  }
  condition {
    path_pattern {
      values = ["/confirm/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_cancel_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 104
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[5]
  }
  condition {
    path_pattern {
      values = ["/cancel/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_webmonitor_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 105
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[6]
  }
  condition {
    path_pattern {
      values = ["/ORS2_WebMonitor/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_printscreport_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 106
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[7]
  }
  condition {
    path_pattern {
      values = ["/ORS2_PrintScReport/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}

resource "aws_lb_listener_rule" "onl_ors_screport_rule" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  priority     = 107
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[8]
  }
  condition {
    path_pattern {
      values = ["/ORS2_ScReport/*"]
    }
  }
  depends_on = [module.alb.http_tcp_listener_arns]
}
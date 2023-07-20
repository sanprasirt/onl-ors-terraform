locals {
  prefix = "onl-ors"
  common_tags = {
    Service     = "onl"
    System      = "ors"
    Owner       = "cpall"
    Environment = var.environment
    Createby    = "TechEx created by terraform"
    SR          = "-"
    Project     = "refactor"
  }
  services_expose = {
    webapp = {
      container_port = 8080,
      target         = 0,
    },
    reserve = {
      container_port = 3000,
      target         = 1,
    },
    search = {
      container_port = 3000,
      target         = 2,
    },
    receive = {
      container_port = 3000,
      target         = 3,
    },
    confirm = {
      container_port = 3000,
      target         = 4,
    },
    cancel = {
      container_port = 3000,
      target         = 5,
    },
    webmonitor = {
      container_port = 8080,
      target         = 6,
    },
    printscreport = {
      container_port = 8080,
      target         = 7,
    },
    screport = {
      container_port = 8080,
      target         = 8,
    },
  }
  
  target_groups = [
    {
      name             = "${local.prefix}-webapp-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip"
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-reserve-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"
      health_check = {
        path                = "/health"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-search-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"
      health_check = {
        path                = "/health"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-receive-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"
      health_check = {
        path                = "/health"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-confirm-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"
      health_check = {
        path                = "/health"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-cancel-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"
      health_check = {
        path                = "/health"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-webmonitor-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip"
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-printscreport-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip"
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
    {
      name             = "${local.prefix}-screport-tg-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip"
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200"
      }
    },
  ]
}

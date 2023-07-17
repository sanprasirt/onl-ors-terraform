# resource "aws_route53_zone" "onl_ors_private_zone" {
#   name = "onl-ors.internal"

#   vpc {
#     vpc_id = var.vpc_id
#   }
#   tags = merge({
#     Name = "onl-ors.internal" },
#     local.common_tags
#   )
# }

# # Create aws_route53_record for onl-ors.internal link to internal ALB
# resource "aws_route53_record" "onl_ors_private_zone_record" {
#   zone_id = aws_route53_zone.onl_ors_private_zone.zone_id
#   name    = "onl-ors.internal"
#   type    = "A"

#   alias {
#     # name                   = aws_elb.main.dns_name
#     name    = module.alb.lb_dns_name
#     zone_id = module.alb.lb_zone_id
#     # zone_id                = aws_elb.main.zone_id
#     evaluate_target_health = true
#   }
#   depends_on = [aws_route53_zone.onl_ors_private_zone, module.alb]
# }
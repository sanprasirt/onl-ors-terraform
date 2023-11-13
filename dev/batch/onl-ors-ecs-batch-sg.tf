module "batch_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"


  name        = "${local.prefix}-batch-sg-${var.environment}"
  description = "Security group for batch"
  vpc_id      = var.vpc_id
  ingress_with_self = [
    {
      description = "Allow HTTPS inbound traffic from the security group"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      self        = true
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp"]

  tags = local.common_tags
}
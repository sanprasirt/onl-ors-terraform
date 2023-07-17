# Create Elasticache cluster
resource "aws_elasticache_cluster" "elasticache_cluster" {
  cluster_id           = "${local.prefix}-redis-${var.environment}"
  engine               = "redis"
  node_type            = var.cache_instance_types[var.environment]
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis_cluster_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_cluster_subnet_group.name


  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache_cluster_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
  tags = merge(
    { Name = "${local.prefix}-redis-${var.environment}" },
    local.common_tags
  )
}

# Create Elasticache REDIS User
# resource "aws_elasticache_user" "elasticache_user" {
#   user_id       = "onlorsdev"
#   user_name     = var.redis_username
#   access_string = "on ~* +@all"
#   engine        = "REDIS"
#   
# }

# Create subnet group
resource "aws_elasticache_subnet_group" "elasticache_cluster_subnet_group" {
  name       = "${local.prefix}-redis-subnet-group"
  subnet_ids = var.aws_app_subnets
}

# Create Sucurity Group for Allow Accress Elasticache
resource "aws_security_group" "redis_cluster_sg" {
  name        = "elasticache-cluster-sg"
  description = "Security group for mq-broker with 6379 ports open within VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow 6379 ports"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    { Name = "elasticache-cluster-sg" },
    local.common_tags
  )
}

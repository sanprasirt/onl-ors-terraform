resource "aws_mq_broker" "rabbit_mq" {
  broker_name = "${local.prefix}-rabbitmq-${var.environment}"

  engine_type        = "RabbitMQ"
  engine_version     = var.engine_version
  host_instance_type = var.mq_instance_types[var.environment]
  security_groups    = [aws_security_group.rabbit_mq_sg.id]
  subnet_ids         = ["subnet-00c5c5986096d3d47"]

  user {
    username = var.mq_username
    password = var.mq_password
  }

  tags = merge(
    { Name = "${local.prefix}-rabbitmq-${var.environment}" },
    local.common_tags
  )
}


# Create Sucurity Group for Allow Accress MQ
resource "aws_security_group" "rabbit_mq_sg" {
  name        = "rabbitmq-sg"
  description = "Security group for mq-broker with 5671 ports open within VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow 5671 ports"
    from_port   = 5671
    to_port     = 5671
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS ports"
    from_port   = 443
    to_port     = 443
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
    { Name = "rabbitmq-sg" },
    local.common_tags
  )
}

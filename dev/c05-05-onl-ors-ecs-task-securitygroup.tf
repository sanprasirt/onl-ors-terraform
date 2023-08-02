resource "aws_security_group" "ecs_task_sg" {
  name   = "ecs-task-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [module.alb_sg.security_group_id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge({
    Name = "ecs-task-sg" },
    local.common_tags
  )
}
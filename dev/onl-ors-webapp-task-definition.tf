# # Create nginx task definition
# resource "aws_ecs_task_definition" "onl_ors_nginx_task" {
#   family             = "${local.prefix}-nginx-service"
#   execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#   memory             = 512
#   cpu                = 256
#   network_mode       = "awsvpc"
#   container_definitions = jsonencode([
#     {
#       name      = "${local.prefix}-nginx-service"
#       image     = "public.ecr.aws/nginx/nginx:1.24"
#       cpu       = 256
#       memory    = 512
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ],
#       logConfiguration : {
#         logDriver : "awslogs",
#         options : {
#           awslogs-create-group : "true",
#           awslogs-group : "/aws/ecs/onl-ors-ecs-cluster-dev",
#           awslogs-region : var.aws_region,
#           awslogs-stream-prefix : "${local.prefix}/nginx-service/ecs-task-nginx-service"
#         }
#       },
#     }
#   ])
#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${local.prefix}-nginx-service"
#     }
#   )
# }

# resource "aws_security_group" "ecs_task_sg" {
#   name   = "ecs-task-sg"
#   vpc_id = var.vpc_id
#   ingress {
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
#   ingress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     security_groups = [module.alb_sg.security_group_id]
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
#   tags = merge({
#     Name = "ecs-task-sg" },
#     local.common_tags
#   )
# }
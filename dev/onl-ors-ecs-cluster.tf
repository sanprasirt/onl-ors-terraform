# # Define provider and region
# provider "aws" {
#   region = "us-west-2"
# }

# # Create VPC
# resource "aws_vpc" "my_vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create private subnet
# resource "aws_subnet" "private_subnet" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-west-2a"
# }

# Create ECS cluster
# resource "aws_ecs_cluster" "onl_ecs_cluster" {
#   name = "${local.prefix}-ecs-cluster-${var.environment}"
#   tags = merge(
#     { Name = "${local.prefix}-ecs-cluster-${var.environment}" },
#     local.common_tags
#   )
# }

# # Create security group for the load balancer
# resource "aws_security_group" "lb_security_group" {
#   name        = "lb-security-group"
#   description = "Security group for the load balancer"

#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create load balancer
# resource "aws_lb" "my_lb" {
#   name               = "my-load-balancer"
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = [aws_subnet.private_subnet.id]
#   security_groups    = [aws_security_group.lb_security_group.id]
# }

# # Create EC2 launch configuration
# resource "aws_launch_configuration" "my_launch_config" {
#   name                 = "my-launch-config"
#   image_id             = "ami-0123456789"
#   instance_type        = "t2.micro"
#   security_groups      = [aws_security_group.lb_security_group.id]
#   iam_instance_profile = "ecsInstanceRole"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Create EC2 Auto Scaling Group
# resource "aws_autoscaling_group" "my_asg" {
#   name                      = "my-auto-scaling-group"
#   launch_configuration      = aws_launch_configuration.my_launch_config.id
#   min_size                  = 1
#   max_size                  = 3
#   desired_capacity          = 1
#   vpc_zone_identifier       = [aws_subnet.private_subnet.id]
#   target_group_arns         = [aws_lb_target_group.my_target_group.arn]
#   health_check_type         = "EC2"
#   termination_policies      = ["OldestInstance"]
#   wait_for_capacity_timeout = "10m"
# }

# # Create target group for the load balancer
# resource "aws_lb_target_group" "my_target_group" {
#   name     = "my-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc.id
# }

# # Create ECS task definition
# resource "aws_ecs_task_definition" "my_task_definition" {
#   family                = "my-task-family"
#   container_definitions = <<DEFINITION
#     [
#       {
#         "name": "my-container",
#         "image": "my-ecr-repo/my-image:latest",
#         "portMappings": [
#           {
#             "containerPort": 80,
#             "hostPort": 80,
#             "protocol": "tcp"
#           }
#         ],
#         "essential": true,
#         "memory": 512,
#         "cpu": 256
#       }
#     ]
#   DEFINITION
# }

# # Create ECS service
# resource "aws_ecs_service" "my_service" {
#   name            = "my-service"
#   cluster         = aws_ecs_cluster.my_cluster.id
#   task_definition = aws_ecs_task_definition.my_task_definition.arn
#   desired_count   = 2
#   launch_type     = "EC2"

#   network_configuration {
#     subnets         = [aws_subnet.private_subnet.id]
#     security_groups = [aws_security_group.lb_security_group.id]

#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.my_target_group.arn
#     container_name   = "my-container"
#     container_port   = 80
#   }
# }

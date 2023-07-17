# # aws_ecs_service.onl_ors_nginx_service:
# resource "aws_ecs_service" "onl_ors_nginx_service" {
#   #   cluster                            = "arn:aws:ecs:ap-southeast-1:802791533053:cluster/onl-ors-ecs-cluster-dev"
#   cluster                            = module.ecs_cluster.arn
#   deployment_maximum_percent         = 200
#   deployment_minimum_healthy_percent = 100
#   desired_count                      = 1
#   enable_ecs_managed_tags            = true
#   health_check_grace_period_seconds  = 0
#   # iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
#   name                = "${local.prefix}-nginx-service"
#   scheduling_strategy = "REPLICA"
#   tags = merge(
#     { Name = "${local.prefix}-nginx-service" },
#     local.common_tags
#   )
#   task_definition = aws_ecs_task_definition.onl_ors_nginx_task.arn

#   capacity_provider_strategy {
#     base              = 1 #20
#     capacity_provider = "asg-1"
#     weight            = 1 #60
#   }

#   deployment_circuit_breaker {
#     enable   = true
#     rollback = true
#   }

#   deployment_controller {
#     type = "ECS"
#   }

#   load_balancer {
#     container_name   = "${local.prefix}-nginx-service"
#     container_port   = 80
#     target_group_arn = element(module.alb.target_group_arns, 0)
#     # target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:802791533053:targetgroup/onl-ors-tg-dev/5696cab485a17f7c"
#   }

#   network_configuration {
#     assign_public_ip = false
#     # security_groups = [
#     #   "sg-03cbb14f1d44c2243",
#     # ]
#     security_groups = [aws_security_group.ecs_task_sg.id]
#     subnets         = var.aws_nonexpose_subnets
#     # subnets = [
#     #   "subnet-00357a44212cc845f",
#     #   "subnet-03b61d2d30d62e4ce",
#     # ]
#   }

#   ordered_placement_strategy {
#     field = "attribute:ecs.availability-zone"
#     type  = "spread"
#   }
#   ordered_placement_strategy {
#     field = "instanceId"
#     type  = "spread"
#   }
# }

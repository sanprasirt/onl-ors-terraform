# resource "aws_ecs_task_definition" "onl_ors_reserv_task" {
#   family             = "${local.prefix}-reserv-service"
#   execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#   memory             = 512
#   cpu                = 256
#   network_mode       = "awsvpc"
#   container_definitions = jsonencode([
#     {
#       name      = "${local.prefix}-reserv-service"
#       image     = "${aws_ecr_repository.onl-ors-reserve.repository_url}:latest"
#       cpu       = 256
#       memory    = 512
#       essential = true
#       portMappings = [
#         {
#           containerPort = 3000
#           hostPort      = 3000
#         }
#       ],
#       environment : [
#         {
#           "name" : "PORT",
#           "value" : "3000"
#         }
#       ],
#       logConfiguration : {
#         logDriver : "awslogs",
#         options : {
#           awslogs-create-group : "true",
#           awslogs-group : "/aws/ecs/onl-ors-ecs-cluster-dev",
#           awslogs-region : var.aws_region,
#           awslogs-stream-prefix : "${local.prefix}/reserv-service/ecs-task-reserv-service"
#         }
#       },
#     }
#   ])

#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${local.prefix}-reserv-service"
#     }
#   )
# }
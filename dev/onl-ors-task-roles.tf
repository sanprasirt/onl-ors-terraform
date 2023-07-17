# Create Role execution tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  for_each = var.services_name
  name     = "${each.key}TaskExecutionRole"

  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    }
    ]
    }
EOF
}

# data "aws_iam_policy_document" "ecs_task_execution_role_bk" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     effect  = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  for_each   = var.services_name
  role       = aws_iam_role.ecs_task_execution_role[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
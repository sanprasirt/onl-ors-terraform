resource "aws_ecs_task_definition" "onl_ors_tasks" {
  for_each                 = var.services_name
  family                   = "${local.prefix}-${each.key}-service"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role[each.key].arn
  memory                   = each.value.memory
  cpu                      = each.value.cpu
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name      = "${local.prefix}-${each.key}-service"
      image     = "${var.repo_url}/onl-ors-${each.key}:latest"
      cpu       = each.value.cpu
      memory    = each.value.memory
      essential = true
      portMappings = [
        {
          containerPort = each.value.port
          hostPort      = each.value.port
        }
      ],
      environment : [
        {
          "name" : "PORT",
          "value" : each.value.variable_port
        },
        {
          "name" : "MQ_HOSTNAME",
          "value" : var.mq_host_with_port
        },
        {
          "name" : "MQ_USERNAME",
          "value" : var.mq_username
        },
        {
          "name" : "MQ_PASSWORD",
          "value" : var.mq_password
        },
        {
          "name" : "DB_CONNECTION_STRING",
          "value" : var.db_connection_string
        },
        {
          "name" : "DB_USERNAME",
          "value" : var.db_username
        },
        {
          "name" : "DB_PASSWORD",
          "value" : var.db_password
        },
        {
          "name" : "REDIS_HOST",
          "value" : aws_elasticache_cluster.elasticache_cluster.cache_nodes.0.address
        },
        {
          "name" : "REDIS_USERNAME",
          "value" : var.redis_username
        },
        {
          "name" : "REDIS_PASSWORD",
          "value" : var.redis_password
        },
        {
          "name" : "NODE_VERSION",
          "value" : "20"
        }
      ],
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-create-group : "true",
          awslogs-group : "/aws/ecs/onl-ors-ecs-cluster-dev",
          awslogs-region : var.aws_region,
          awslogs-stream-prefix : "${local.prefix}/${each.key}-service/ecs-task-${each.key}-service"
        }
      },
    }
  ])
  depends_on = [aws_iam_role.ecs_task_execution_role]
  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-${each.key}-service"
    }
  )
  lifecycle {
    ignore_changes = [container_definitions]
  }
}
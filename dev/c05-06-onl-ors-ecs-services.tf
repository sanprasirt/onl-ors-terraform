# Create aws_ecs_service

resource "aws_ecs_service" "onl_ors_services" {
  for_each                           = local.services_expose
  cluster                            = module.ecs_cluster.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  enable_ecs_managed_tags            = true
  health_check_grace_period_seconds  = 0
  name                               = "${local.prefix}-${each.key}-service"
  scheduling_strategy                = "REPLICA"
  tags = merge(
    { Name = "${local.prefix}-${each.key}-service" },
    local.common_tags
  )
  task_definition = aws_ecs_task_definition.onl_ors_tasks[each.key].arn
  # Update for not conflic with aws pipeline
  # task_definition = "arn:aws:ecs:ap-southeast-1:802791533053:task-definition/onl-ors-${each.key}-service:2"
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
  capacity_provider_strategy {
    base              = 20
    capacity_provider = "asg-1"
    weight            = 60
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name = "${local.prefix}-${each.key}-service"

    container_port = each.value.container_port
    # target_group_arn = element(module.alb.target_group_arns, 1)
    target_group_arn = module.alb.target_group_arns[each.value.target]
  }

  network_configuration {
    assign_public_ip = false
    # security_groups = [
    #   "sg-03cbb14f1d44c2243",
    # ]
    security_groups = [aws_security_group.ecs_task_sg.id]
    subnets         = var.aws_nonexpose_subnets
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
  # ordered_placement_strategy {
  #   field = "instanceId"
  #   type  = "spread"
  # }
  ordered_placement_strategy {
    field = "memory"
    type  = "binpack"
  }

  depends_on = [ module.alb, aws_ecs_task_definition.onl_ors_tasks, aws_iam_role.ecs_task_execution_role]
}

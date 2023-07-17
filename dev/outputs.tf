
# Generated API GW endpoint URL that can be used to access the application running on a private ECS Fargate cluster.
output "onl_ors_apigw_endpoint" {
  value       = aws_apigatewayv2_api.apigw_http_endpoint.api_endpoint
  description = "API Gateway Endpoint"
}

# MQ Broker url
output "onl_ors_mq_broker_url" {
  value       = aws_mq_broker.rabbit_mq.instances.0.ip_address
  description = "MQ Broker url"
}

output "onl_ors_cache_url" {
  value       = aws_elasticache_cluster.elasticache_cluster.cache_nodes.0.address
  description = "ElasticCache Redis url"
}

################################################################################
# ECR Repo 
################################################################################
output "onl_ors_repository_url" {
  description = "Url of image repository"
  value       = aws_ecr_repository.onl-ors-search.repository_url
}
################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "ARN that identifies the cluster"
  value       = module.ecs_cluster.arn
}

output "cluster_id" {
  description = "ID that identifies the cluster"
  value       = module.ecs_cluster.id
}

output "cluster_name" {
  description = "Name that identifies the cluster"
  value       = module.ecs_cluster.name
}

output "cluster_capacity_providers" {
  description = "Map of cluster capacity providers attributes"
  value       = module.ecs_cluster.cluster_capacity_providers
}

output "cluster_autoscaling_capacity_providers" {
  description = "Map of capacity providers created and their attributes"
  value       = module.ecs_cluster.autoscaling_capacity_providers
}

output "cluster_alb_target_group_arns" {
  description = "Map of target group created and their attributes"
  value       = module.alb.target_group_arns
}

output "cluster_alb_dns_name" {
  description = "Map of ALB access alb dns"
  value       = module.alb.lb_dns_name
}
# ################################################################################
# # Service
# ################################################################################

# output "service_id" {
#   description = "ARN that identifies the service"
#   value       = module.ecs_service.id
# }

# output "service_name" {
#   description = "Name of the service"
#   value       = module.ecs_service.name
# }

# output "service_iam_role_name" {
#   description = "Service IAM role name"
#   value       = module.ecs_service.iam_role_name
# }

# output "service_iam_role_arn" {
#   description = "Service IAM role ARN"
#   value       = module.ecs_service.iam_role_arn
# }

# output "service_iam_role_unique_id" {
#   description = "Stable and unique string identifying the service IAM role"
#   value       = module.ecs_service.iam_role_unique_id
# }

# output "service_container_definitions" {
#   description = "Container definitions"
#   value       = module.ecs_service.container_definitions
# }

# output "service_task_definition_arn" {
#   description = "Full ARN of the Task Definition (including both `family` and `revision`)"
#   value       = module.ecs_service.task_definition_arn
# }

# output "service_task_definition_revision" {
#   description = "Revision of the task in a particular family"
#   value       = module.ecs_service.task_definition_revision
# }

# output "service_task_exec_iam_role_name" {
#   description = "Task execution IAM role name"
#   value       = module.ecs_service.task_exec_iam_role_name
# }

# output "service_task_exec_iam_role_arn" {
#   description = "Task execution IAM role ARN"
#   value       = module.ecs_service.task_exec_iam_role_arn
# }

# output "service_task_exec_iam_role_unique_id" {
#   description = "Stable and unique string identifying the task execution IAM role"
#   value       = module.ecs_service.task_exec_iam_role_unique_id
# }

# output "service_tasks_iam_role_name" {
#   description = "Tasks IAM role name"
#   value       = module.ecs_service.tasks_iam_role_name
# }

# output "service_tasks_iam_role_arn" {
#   description = "Tasks IAM role ARN"
#   value       = module.ecs_service.tasks_iam_role_arn
# }

# output "service_tasks_iam_role_unique_id" {
#   description = "Stable and unique string identifying the tasks IAM role"
#   value       = module.ecs_service.tasks_iam_role_unique_id
# }

# output "service_task_set_id" {
#   description = "The ID of the task set"
#   value       = module.ecs_service.task_set_id
# }

# output "service_task_set_arn" {
#   description = "The Amazon Resource Name (ARN) that identifies the task set"
#   value       = module.ecs_service.task_set_arn
# }

# output "service_task_set_stability_status" {
#   description = "The stability status. This indicates whether the task set has reached a steady state"
#   value       = module.ecs_service.task_set_stability_status
# }

# output "service_task_set_status" {
#   description = "The status of the task set"
#   value       = module.ecs_service.task_set_status
# }

# output "service_autoscaling_policies" {
#   description = "Map of autoscaling policies and their attributes"
#   value       = module.ecs_service.autoscaling_policies
# }

# output "service_autoscaling_scheduled_actions" {
#   description = "Map of autoscaling scheduled actions and their attributes"
#   value       = module.ecs_service.autoscaling_scheduled_actions
# }
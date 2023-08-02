# module "onl_ors_batch" {
#   source = "terraform-aws-modules/batch/aws"
#   version = "2.0.1"

#   instance_iam_role_name = "${local.prefix}-batch-role"
#   instance_iam_role_path = "/batch/"
#   instance_iam_role_description = "IAM role for AWS Batch instances"
#   instance_iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
#   instance_iam_role_tags = {
#     ModuleCreatedRole = "Yes"
#   }
#   service_iam_role_name = "${local.prefix}-batch-service-role"
#   service_iam_role_path = "/batch/"
#   service_iam_role_description = "IAM role for AWS Batch service"
#   service_iam_role_tags = {
#     ModuleCreatedRole = "Yes"
#   }

#   compute_environments = {
#     ec2 = {
#         name = "${local.prefix}-batch-cluster-${var.environment}"
#         # name_prefix = "${local.prefix}-batch-${var.environment}"
#         type = "MANAGED"
#         compute_resources = {
#             type = "EC2"
#             instance_types = ["optimal"]
#             min_vcpus = 0
#             max_vcpus = 4
#             desired_vcpus = 0
#             security_group_ids = [module.batch_security_group.security_group_id]
#             subnets = var.aws_nonexpose_subnets
#             tags = merge(
#                 { Name = "${local.prefix}-batch-${var.environment}"
#                 Type = "EC2" },
#                 local.common_tags
#             )
#         }
#     }
#   }
#   # Create first jobs definition
#   # job_definitions = {
#   #   onl_ors_updateStoreFC_job = {
#   #     name = "${local.prefix}-batch-job-definition-${var.environment}"
#   #     propagate_tags = true
      
#   #     container_properties = jsonencode({
#   #       comamannd = "java -jar ors-updateStoreFC.jar"
#   #       image = "${var.repo_url}/onl-ors-updatestorefc:latest"
#   #       resourceRequirements = [
#   #       {
#   #         type = "VCPU"
#   #         value = "1"
#   #       },
#   #       {
#   #         type = "MEMORY"
#   #         value = "1024"
#   #       }
#   #     ]
#   #     logConfiguration = {
#   #       logDriver = "awslogs"
#   #       options = {
#   #         awslogs-group = aws_cloudwatch_log_group.this.name
#   #         awslogs-region = var.aws_region
#   #         awslogs-stream-prefix = "onl-ors-updatestorefc"
#   #       }
#   #       }
#   #     })
#   #     attempt_duration_seconds = 120
#   #     retry_strategy = {
#   #       attempts = 1
#   #       evaluation_on_exit = {
#   #         retry_error = {
#   #           action = "RETRY"
#   #           on_exit_code = 1
#   #         }
#   #         exit_success = {
#   #           action = "EXIT"
#   #           on_exit_code = 0
#   #         }
#   #       }
#   #     }
#   #     tags = merge(
#   #       { Name = "${local.prefix}-updatestore-job-definition-${var.environment}" },
#   #       local.common_tags
#   #     )
#   #   }
#   # }
# }

# resource "aws_cloudwatch_log_group" "this" {
#     name              = "${local.prefix}-batch-log-group"
#     retention_in_days = 7
#     tags = merge(
#         { Name = "${local.prefix}-batch-log-group" },
#         local.common_tags
#     )
# }
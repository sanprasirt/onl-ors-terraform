output "onl_ors_compute_environments" {
  value       = module.onl_ors_batch.compute_environments
  description = "Batch Compute environments"
}

output "onl_ors_instance_iam_instance_profile_arn" {
  value       = module.onl_ors_batch.instance_iam_instance_profile_arn
  description = "Batch Instance IAM Instance Profile ARN"
}

output "onl_ors_instance_iam_role_arn" {
  value       = module.onl_ors_batch.instance_iam_role_arn
  description = "Batch Instance IAM Role ARN"
}
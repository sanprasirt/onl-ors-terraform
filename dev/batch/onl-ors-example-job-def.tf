resource "aws_batch_job_definition" "example-job" {
  name           = "BatchJob-Example"
  type           = "container"
  propagate_tags = true
  container_properties = jsonencode({
    command = ["s3", "ls"],
    image   = "public.ecr.aws/aws-cli/aws-cli:2.13.29"
    resourceRequirements = [
      {
        type  = "VCPU"
        value = "1"
      },
      {
        type  = "MEMORY"
        value = "1024"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.this.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "batch-job-example"
      }
    }
    executionRoleArn = aws_iam_role.batch_job_exec_role.arn
  })
}

# resource "aws_scheduler_schedule" "example-batch-schedule" {
#   name        = "${local.prefix}-submit-batch-job-schedule-${var.environment}"
#   description = "Schedule to submit a batch job"
#   flexible_time_window {
#     mode = "OFF"
#   }
#   schedule_expression = "rate(30 minute)" # every 5 minute
#   schedule_expression_timezone = "Asia/Bangkok"
#   target {
#     arn      = "arn:aws:scheduler:::aws-sdk:batch:submitJob"
#     role_arn = aws_iam_role.schedule_batch_role.arn
#     input = jsonencode({
#       "JobDefinition" = aws_batch_job_definition.example-job.arn
#       "JobName"      = "BatchJob-Example"
#       "JobQueue"      = aws_batch_job_queue.onl_ors_batch_job_queue.arn
#     })
#   }
# }
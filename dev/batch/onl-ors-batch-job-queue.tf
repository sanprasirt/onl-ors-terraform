# Create the batch job queue
resource "aws_batch_job_queue" "onl_ors_batch_job_queue" {
  name     = "${local.prefix}-batch-job-queue-${var.environment}"
  priority = 1
  state    = "ENABLED"
  compute_environments = [
    module.onl_ors_batch.compute_environments["ec2"].arn
  ]
}

resource "aws_iam_role" "batch_job_exec_role" {
  name               = "${local.prefix}-batch-job-exec-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "batch_job_exec_role_policy" {
  role       = aws_iam_role.batch_job_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Schedule to submit a batch job role
resource "aws_iam_policy" "schedule_batch_policy" {
  name = "${local.prefix}-schedule-batch-policy-${var.environment}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "batch:SubmitJob",
          "batch:DescribeJobs",
          "batch:ListJobs",
          "batch:TerminateJob"
        ],
        Resource = "*"
      },
      {
        "Action" : [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "schedule_batch_role" {
  name                = "${local.prefix}-schedule-batch-role-${var.environment}"
  managed_policy_arns = [aws_iam_policy.schedule_batch_policy.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sts:AssumeRole"]
        Sid    = ""
        Principal = {
          Service = ["scheduler.amazonaws.com"]
        }
      },
    ]
  })
}
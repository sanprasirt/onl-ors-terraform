resource "aws_codebuild_project" "onl_ors_codebuild" {
  name        = "${local.prefix}-${var.environment}-codebuild"
  description = "${local.prefix}-${var.environment}-codebuild"
  service_role       = aws_iam_role.onl_ors_codebuild_role.arn
  project_visibility = "PRIVATE"
  artifacts {
    type = "CODEPIPELINE"
  }
  source {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "802791533053"
    }

    environment_variable {
      name  = "AWS_REGION"
      value = "${var.aws_region}"
    }
  }
    logs_config {
      cloudwatch_logs {
        group_name  = "/aws/codebuild/${local.prefix}-${var.environment}-codebuild"
        stream_name = ""
      }
    }
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.prefix}-${var.environment}-codebuild"
    })
}
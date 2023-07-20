resource "aws_codebuild_project" "onl-ors-codebuild" {
  name          = "onl-ors-uat-codebuild"
  description   = "onl-ors-uat-codebuild"
  service_role  = "arn:aws:iam::802791533053:role/dvp-cicd-deployer-role"
  project_visibility = "PRIVATE"
  artifacts {
    type = "CODEPIPELINE"
  }
  source {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "802791533053"
    }

    environment_variable {
      name  = "AWS_REGION"
      value = "ap-southeast-1"
    }
  }
#   logs_config {
#     cloudwatch_logs {
#       group_name  = "log-group"
#       stream_name = "log-stream"
#     }
#   }
}
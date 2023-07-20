locals {
    repo_name = {
      "reserve" = "${local.prefix}-reserve-2"
      # "search" = "${local.prefix}-search"
      # "receive" = "${local.prefix}-receive"
      # "confirm" = "${local.prefix}-confirm"
      # "cancel" = "${local.prefix}-cancel"
      # "mq-consume" = "${local.prefix}-mq-consume"
      # "mq-consume-product" = "${local.prefix}-mq-consume-product"
      # "webmonitor" = "${local.prefix}-webmonitor"
      # "printscreport" = "${local.prefix}-printscreport"
      # "webapp" = "${local.prefix}-webapp"
      # "screport" = "${local.prefix}-screport"
    }
  }
variable "create_codepipeline" {
  type    = bool
  default = false
}
resource "aws_codepipeline" "onl_ors_codepipeline" {
  for_each = var.create_codepipeline ? local.repo_name : {}
  name     = "${each.value}-${var.environment}-codepipeline"
  role_arn = "arn:aws:iam::802791533053:role/service-role/Onl-Ors-AWSCodePipelineServiceRole"
  artifact_store {
    location = "codepipeline-${var.aws_region}-915051222475"
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
        name            = "Source"
        category        = "Source"
        owner           = "AWS"
        provider        = "CodeCommit"
        version         = "1"
        output_artifacts = ["SourceArtifact"]
        region = "${var.aws_region}"
        configuration = {
            RepositoryName = "${each.value}"
            BranchName     = "uat"
            OutputArtifactFormat   = "CODE_ZIP"
        }
    }
  }

  stage {
    name = "Build"
    action {
      name = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      region = "${var.aws_region}"
      configuration = {
        ProjectName = aws_codebuild_project.onl_ors_codebuild.name
      }
    }
  }
  tags = merge(local.common_tags, {
    "Name" = "${each.value}-${var.environment}-codepipeline"
  })
}

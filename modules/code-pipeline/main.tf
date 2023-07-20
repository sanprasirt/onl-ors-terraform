resource "aws_codebuild_project" "this" {
  for_each    = var.create_codebuild ? toset(var.codebuild) : []
  name        = "onl-ors-uat-codebuild"
  description = "onl-ors-uat-codebuild"
  # service_role       = "arn:aws:iam::802791533053:role/dvp-cicd-deployer-role"
  service_role       = aws_iam_role.this.arn
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

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = "onl-ors-codebuild-service-role-uat"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "lambda:*",
      "events:*",
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:GetRole",
      "iam:DeleteRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "cloudformation:*",
      "codebuild:*",
      "ecr:*",
      "ecs:*",
      "ec2:*",
      "opsworks:*",
      "elasticloadbalancing:*",
      "autoscaling:*"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketPolicy",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::codepipeline-ap-southeast-1-915051222475",
      "arn:aws:s3:::codepipeline-ap-southeast-1-915051222475/*",
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "onl-ors-codebuild-policy-uat"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this.json
}




# resource "aws_codepipeline" "codepipeline" {
#   for_each = var.create_codebuild ? toset(var.codebuild) : []
#   name     = "onl-ors-reserve-uat-codepipeline"
#   role_arn = "arn:aws:iam::802791533053:role/service-role/Onl-Ors-AWSCodePipelineServiceRole"
#   artifact_store {
#     location = "codepipeline-ap-southeast-1-915051222475"
#     type     = "S3"
#   }

#   stage {
#     name = "Source"
#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = "CodeCommit"
#       version          = "1"
#       output_artifacts = ["SourceArtifact"]
#       region           = "ap-southeast-1"
#       configuration = {
#         RepositoryName       = "onl-ors-reserve-uat"
#         BranchName           = "uat"
#         OutputArtifactFormat = "CODE_ZIP"
#       }
#     }
#   }

#   stage {
#     name = "Build"
#     action {
#       name             = "Build"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       input_artifacts  = ["SourceArtifact"]
#       output_artifacts = ["BuildArtifact"]
#       version          = "1"
#       region           = "ap-southeast-1"
#       configuration = {
#         ProjectName = "onl-ors-reserve-uat"
#       }
#     }
#   }
# }

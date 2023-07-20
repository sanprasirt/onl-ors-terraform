# data "aws_iam_policy_document" "codepipeline_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["codepipeline.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "codepipeline_role" {
#   name               = "${local.prefix}-codepipeline-service-role-${var.environment}"
#   assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
# }

# data "aws_iam_policy_document" "codepipeline_policy" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:GetObject",
#       "s3:GetObjectVersion",
#       "s3:GetBucketVersioning",
#       "s3:PutObjectAcl",
#       "s3:PutObject",
#     ]

#     resources = [
#       "arn:aws:s3:::codepipeline-ap-southeast-1-915051222475",
#       "arn:aws:s3:::codepipeline-ap-southeast-1-915051222475/*",
#     ]
#   }

#   statement {
#     effect    = "Allow"
#     actions   = ["codestar-connections:UseConnection"]
#     resources = [aws_codestarconnections_connection.example.arn]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "codebuild:BatchGetBuilds",
#       "codebuild:StartBuild",
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "codepipeline_policy" {
#   name   = "${local.prefix}-codepipeline-policy-${var.environment}"
#   role   = aws_iam_role.codepipeline_role.id
#   policy = data.aws_iam_policy_document.codepipeline_policy.json
# }

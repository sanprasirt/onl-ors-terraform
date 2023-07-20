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

resource "aws_iam_role" "onl_ors_codebuild_role" {
  name               = "${local.prefix}-codebuild-service-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codebuild_policy_document" {
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

resource "aws_iam_role_policy" "codebuild_role_policy" {
  name   = "${local.prefix}-codebuild-policy-${var.environment}"
  role   = aws_iam_role.onl_ors_codebuild_role.name
  policy = data.aws_iam_policy_document.codebuild_policy_document.json
}
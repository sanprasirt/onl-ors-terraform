
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "onl_ors_alb_logs" {
  bucket        = "${local.prefix}-alb-logs-${var.environment}"
#   acl           = "log-delivery-write"
  force_destroy = true

}

resource "aws_s3_bucket_policy" "onl_ors_alb_logs" {
  bucket = aws_s3_bucket.onl_ors_alb_logs.id
  policy = data.aws_iam_policy_document.s3_bucket_lb_write.json
}


data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.onl_ors_alb_logs.arn}/*",
    ]

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.onl_ors_alb_logs.arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }


  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.onl_ors_alb_logs.arn}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

output "bucket_name" {
  value = "${aws_s3_bucket.onl_ors_alb_logs.bucket}"
}
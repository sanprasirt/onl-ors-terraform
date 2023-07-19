data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.onl_ors_apigw_rest_api.execution_arn}/*"]
  }
}
resource "aws_api_gateway_rest_api_policy" "onl_ors_apigw_policy" {
  rest_api_id = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.id
  policy      = data.aws_iam_policy_document.this.json
}

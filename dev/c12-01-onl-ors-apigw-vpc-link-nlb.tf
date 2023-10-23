data "aws_region" "current" {}

resource "aws_api_gateway_vpc_link" "onl_ors_apigw_vpc_link" {
  name = "${local.prefix}-vpclink-${var.environment}"
  description = "VPC Link for API Gateway to private NLB"
  target_arns = [aws_lb.onl_ors_nlb.arn]

  tags = merge(
    { Name = "${local.prefix}-vpclink-${var.environment}" },
    local.common_tags
  )
}


resource "aws_api_gateway_rest_api" "onl_ors_apigw_rest_api" {
  name = "${local.prefix}-apigateway-${var.environment}"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.onl_ors_vpc_endpoint.id]
    }
}

resource "aws_api_gateway_resource" "onl_ors_apigw_rs" {
  parent_id   = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.id
}

resource "aws_api_gateway_method" "onl_ors_method_any" {
  rest_api_id   = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.id
  resource_id   = aws_api_gateway_resource.onl_ors_apigw_rs.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "onl_ors_apigw_integration" {
  rest_api_id = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.id
  resource_id = aws_api_gateway_resource.onl_ors_apigw_rs.id
  http_method = aws_api_gateway_method.onl_ors_method_any.http_method
  integration_http_method = "ANY"

  type = "HTTP_PROXY"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
  
  uri = "http://${aws_lb.onl_ors_nlb.dns_name}/{proxy}"
  connection_type = "VPC_LINK"
  connection_id = aws_api_gateway_vpc_link.onl_ors_apigw_vpc_link.id
}


resource "aws_api_gateway_deployment" "onl_ors_apigw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.onl_ors_apigw_rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [ aws_api_gateway_rest_api_policy.onl_ors_apigw_policy ]
}

resource "aws_api_gateway_stage" "onl_ors_apigw_stage" {
  deployment_id = aws_api_gateway_deployment.onl_ors_apigw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.id
  stage_name    = "${var.environment}"
}



resource "aws_vpc_endpoint" "onl_ors_vpc_endpoint" {
  private_dns_enabled = false
#   security_group_ids  = [aws_default_security_group.example.id]
  service_name        = "com.amazonaws.${data.aws_region.current.name}.execute-api"
  subnet_ids          = var.aws_app_subnets
  vpc_endpoint_type   = "Interface"
  vpc_id              = var.vpc_id
  security_group_ids = [module.apigateway_sg.security_group_id]

  tags = merge(
    { Name = "${local.prefix}-api-vpce-${var.environment}"},
    local.common_tags
  )
}

# Domain Name
# resource "aws_api_gateway_domain_name" "onl_ors_apigw_domain_name" {
#   certificate_arn    = "arn:aws:acm:ap-southeast-1:802791533053:certificate/acf3e7ec-a2a6-4030-bfc7-d13cbdc6bf84"
  
#   # certificate_arn = "arn:aws:acm:ap-southeast-1:802791533053:certificate/acf3e7ec-a2a6-4030-bfc7-d13cbdc6bf84"
#   domain_name     = "onl-ors-dev.cpall.co.th"
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_base_path_mapping" "onl_ors_apigw_base_path_mapping" {
#   api_id      = aws_api_gateway_rest_api.onl_ors_apigw_rest_api.id
#   stage_name  = aws_api_gateway_stage.onl_ors_apigw_stage.stage_name
#   domain_name = aws_api_gateway_domain_name.onl_ors_apigw_domain_name.domain_name
# }

module "apigateway_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name = "${local.prefix}-vpce-${var.environment}-sg"
  description = "Security group for VPC Endpoint Call API"
  vpc_id = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["https-443-tcp","http-80-tcp"]
  
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = local.common_tags
}
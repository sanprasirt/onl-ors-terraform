# Create the VPC Link configured with the private subnets
resource "aws_apigatewayv2_vpc_link" "vpclink_apigw_to_alb" {
  name               = "vpclink_apigw_to_alb"
  security_group_ids = []
  subnet_ids         = var.aws_app_subnets
  tags = merge({
    Name = "${local.prefix}-ecs-pvt-endpoint"
    },
  local.common_tags)
}

# Create the API Gateway HTTP endpoint
resource "aws_apigatewayv2_api" "apigw_http_endpoint" {
  name          = "${local.prefix}-ecs-pvt-endpoint"
  protocol_type = "HTTP"
  tags = merge({
    Name = "${local.prefix}-ecs-pvt-endpoint"
  }, local.common_tags)
}

# Create the API Gateway HTTP_PROXY integration between the created API and the private load balancer via the VPC Link
resource "aws_apigatewayv2_integration" "apigw_integration" {
  api_id           = aws_apigatewayv2_api.apigw_http_endpoint.id
  integration_type = "HTTP_PROXY"
  integration_uri  = element(module.alb.http_tcp_listener_arns, 0)

  integration_method     = "ANY"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb.id
  payload_format_version = "1.0"
  depends_on = [aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb,
    aws_apigatewayv2_api.apigw_http_endpoint,
  module.alb.http_tcp_listener_arns]
}

# Create the API route with proxy method
# resource "aws_apigatewayv2_route" "apigw_route" {
#   for_each   = toset(["ORS2_POS_CLIENT47", "reserve", "confirm", "search", "receive", "cancel", "onl-ors-webmonitor"])
#   # for_each = local.services_expose
#   api_id     = aws_apigatewayv2_api.apigw_http_endpoint.id
#   route_key  = "ANY /${each.key}/{proxy+}"
#   target     = "integrations/${aws_apigatewayv2_integration.apigw_integration.id}"
#   depends_on = [aws_apigatewayv2_integration.apigw_integration]
# }

# Create API Gateway HTTP API JWT Authorizer
# resource "aws_apigatewayv2_authorizer" "apigw_auth" {
#   api_id = aws_apigatewayv2_api.apigw_http_endpoint.id
#   authorizer_type = "JWT"
#   identity_sources = ["$request.header.Authorization"]
#   name = "${local.prefix}-apigw-auth"
#   jwt_configuration {
#     audience = ["${local.prefix}-ecs-pvt-endpoint"]
#     issuer = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.cognito_pool.id}"
#   }
# }

# Set a default stage
resource "aws_apigatewayv2_stage" "apigw_stage" {
  api_id      = aws_apigatewayv2_api.apigw_http_endpoint.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_log.arn
    format          = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
  }
  # default_route_settings {
  #   detailed_metrics_enabled = true
  #   logging_level            = "INFO"
  #   throttling_burst_limit   = 5000
  #   throttling_rate_limit    = 10000
  # }

  depends_on = [aws_apigatewayv2_api.apigw_http_endpoint]
}

# # Create the VPC Link configured with the private subnets. Security groups are kept empty here, but can be configured as required.
# resource "aws_apigatewayv2_vpc_link" "vpclink_apigw_to_alb" {
#   name               = "vpclink_apigw_to_alb"
#   security_group_ids = []
#   subnet_ids         = var.aws_app_subnets
# }

# # Create the API Gateway HTTP endpoint
# resource "aws_apigatewayv2_api" "apigw_http_endpoint" {
#   name          = "ecs-pvt-endpoint"
#   protocol_type = "HTTP"
# }

# # Create the API Gateway HTTP_PROXY integration between the created API and the private load balancer via the VPC Link.
# # Ensure that the 'DependsOn' attribute has the VPC Link dependency.
# # This is to ensure that the VPC Link is created successfully before the integration and the API GW routes are created.
# resource "aws_apigatewayv2_integration" "apigw_integration" {
#   api_id           = aws_apigatewayv2_api.apigw_http_endpoint.id
#   integration_type = "HTTP_PROXY"
#   integration_uri  = element(module.alb.http_tcp_listener_arns, 0)

#   integration_method     = "ANY"
#   connection_type        = "VPC_LINK"
#   connection_id          = aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb.id
#   payload_format_version = "1.0"
#   depends_on = [aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb,
#     aws_apigatewayv2_api.apigw_http_endpoint,
#   module.alb.http_tcp_listener_arns]
# }

# API GW route with ANY method
resource "aws_apigatewayv2_route" "apigw_route" {
  api_id     = aws_apigatewayv2_api.apigw_http_endpoint.id
  route_key  = "ANY /{proxy+}"
  target     = "integrations/${aws_apigatewayv2_integration.apigw_integration.id}"
  depends_on = [aws_apigatewayv2_integration.apigw_integration]
}

# # Set a default stage
# resource "aws_apigatewayv2_stage" "apigw_stage" {
#   api_id      = aws_apigatewayv2_api.apigw_http_endpoint.id
#   name        = "$default"
#   auto_deploy = true
#   depends_on  = [aws_apigatewayv2_api.apigw_http_endpoint]
# }
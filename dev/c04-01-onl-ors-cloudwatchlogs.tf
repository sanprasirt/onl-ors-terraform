# Create Cloudwatch log groups
resource "aws_cloudwatch_log_group" "elasticache_cluster_log" {
  name              = "/aws/elasticache/${local.prefix}-redis-${var.environment}"
  retention_in_days = 30
  tags              = local.common_tags
}

# Create Cloudwatch log groups for Api Gateway
resource "aws_cloudwatch_log_group" "api_gateway_log" {
  name              = "/aws/apigateway/${local.prefix}-api-gateway-${var.environment}"
  retention_in_days = 30
  tags              = local.common_tags
}
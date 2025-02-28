# -------------------------------
# API Gateway: URL Shortener API
# -------------------------------

# Create the API Gateway REST API
resource "aws_api_gateway_rest_api" "url_shortener_api" {
  name        = "url-shortener-api"
  description = "API Gateway for URL Shortener"
}

# -------------------------------
# Define API Resources
# -------------------------------

# Create the /shorten resource (for creating short URLs)
resource "aws_api_gateway_resource" "shorten" {
  rest_api_id = aws_api_gateway_rest_api.url_shortener_api.id
  parent_id   = aws_api_gateway_rest_api.url_shortener_api.root_resource_id
  path_part   = "shorten"
}

# Create the /{short_code} resource (for redirecting short URLs)
resource "aws_api_gateway_resource" "short_code" {
  rest_api_id = aws_api_gateway_rest_api.url_shortener_api.id
  parent_id   = aws_api_gateway_rest_api.url_shortener_api.root_resource_id
  path_part   = "{short_code}"
}

# -------------------------------
# Define HTTP Methods
# -------------------------------

# POST /shorten - Endpoint to create short URLs
resource "aws_api_gateway_method" "post_shorten" {
  rest_api_id   = aws_api_gateway_rest_api.url_shortener_api.id
  resource_id   = aws_api_gateway_resource.shorten.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true  # Require API Key for security
}

# GET /{short_code} - Endpoint to redirect to original URL
resource "aws_api_gateway_method" "get_redirect" {
  rest_api_id   = aws_api_gateway_rest_api.url_shortener_api.id
  resource_id   = aws_api_gateway_resource.short_code.id
  http_method   = "GET"
  authorization = "NONE"
}

# -------------------------------
# Lambda Integration
# -------------------------------

# Declare variables for Lambda function ARNs (passed from root module)
variable "shorten_lambda_arn" {}
variable "redirect_lambda_arn" {}

# Connect POST /shorten to Lambda (Shorten a URL)
resource "aws_api_gateway_integration" "post_shorten" {
  rest_api_id             = aws_api_gateway_rest_api.url_shortener_api.id
  resource_id             = aws_api_gateway_resource.shorten.id
  http_method             = aws_api_gateway_method.post_shorten.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.shorten_lambda_arn # Use the variable passed from root module
}

# Connect GET /{short_code} to Lambda (Redirect to URL)
resource "aws_api_gateway_integration" "get_redirect" {
  rest_api_id             = aws_api_gateway_rest_api.url_shortener_api.id
  resource_id             = aws_api_gateway_resource.short_code.id
  http_method             = aws_api_gateway_method.get_redirect.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.redirect_lambda_arn # Use the variable passed from root module
}

# -------------------------------
# API Key & Usage Plan
# -------------------------------

# Create an API Key for access control
resource "aws_api_gateway_api_key" "url_shortener_key" {
  name        = "url-shortener-api-key"
  description = "API Key for URL Shortener API"
  enabled     = true
}

# Create a Usage Plan for API Key restrictions
resource "aws_api_gateway_usage_plan" "url_shortener_plan" {
  name        = "url-shortener-usage-plan"
  description = "Usage plan for API Gateway"

  api_stages {
    api_id = aws_api_gateway_rest_api.url_shortener_api.id
    stage  = aws_api_gateway_deployment.prod.stage_name
  }
}

# Associate the API Key with the Usage Plan
resource "aws_api_gateway_usage_plan_key" "api_key_association" {
  key_id        = aws_api_gateway_api_key.url_shortener_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.url_shortener_plan.id
}

# -------------------------------
# Deploy API Gateway
# -------------------------------

# Deploy API Gateway and create the "prod" stage
resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = aws_api_gateway_rest_api.url_shortener_api.id
  stage_name  = "prod"

  # Redeploy API Gateway if methods/resources change
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.url_shortener_api))
  }

  depends_on = [
    aws_api_gateway_integration.post_shorten,
    aws_api_gateway_integration.get_redirect
  ]
}


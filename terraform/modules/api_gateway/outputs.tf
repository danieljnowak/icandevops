# -------------------------------
# API Gateway Outputs
# -------------------------------

# API Gateway URL for invoking the endpoints
output "api_gateway_url" {
  value = aws_api_gateway_deployment.prod.invoke_url
}


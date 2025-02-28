# -------------------------------
# Outputs for API Gateway Module
# -------------------------------

output "shorten_lambda_arn" {
  description = "ARN of the shorten Lambda function"
  value       = aws_lambda_function.shorten_lambda.arn
}

output "redirect_lambda_arn" {
  description = "ARN of the redirect Lambda function"
  value       = aws_lambda_function.redirect_lambda.arn
}

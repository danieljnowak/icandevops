# -------------------------------
# Outputs for Other Modules
# -------------------------------
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.cdn.hosted_zone_id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

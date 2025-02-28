# -------------------------------
# Input Variables for S3 Static Site Module
# -------------------------------
variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for invalidations"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront domain name for the S3 bucket"
  type        = string
}

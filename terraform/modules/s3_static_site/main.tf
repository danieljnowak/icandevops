# -------------------------------
# S3 Bucket for Hugo Static Site
# -------------------------------
resource "aws_s3_bucket" "website" {
  bucket = "dannowak-hugo-site"
}

# -------------------------------
# S3 Bucket Ownership Controls (Required for ACL Updates)
# -------------------------------
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# -------------------------------
# S3 Bucket Public Access Block (Allows CloudFront to Access)
# -------------------------------
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# -------------------------------
# Fetch AWS Account ID for CloudFront Policy
# -------------------------------
data "aws_caller_identity" "current" {}

# -------------------------------
# S3 Bucket Policy for CloudFront Access
# -------------------------------
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.website.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
          }
        }
      }
    ]
  })
}

# -------------------------------
# S3 Website Configuration
# -------------------------------
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# -------------------------------
# Outputs for Other Modules
# -------------------------------
output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}

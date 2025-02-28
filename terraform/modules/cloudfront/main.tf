# -------------------------------
# CloudFront Distribution
# -------------------------------

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = var.s3_bucket_regional_domain_name
    origin_id   = "S3-dannowak-hugo-site"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-dannowak-hugo-site"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# -------------------------------
# ACM SSL Certificate for CloudFront
# -------------------------------
resource "aws_acm_certificate" "cert" {
  domain_name       = "dannowak.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------------
# Terraform Provider Configuration
# -------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# -------------------------------
# Route 53: DNS Zone for dannowak.com
# -------------------------------
resource "aws_route53_zone" "main" {
  name = "dannowak.com"
}

# -------------------------------
# ACM Certificate for CloudFront
# -------------------------------
resource "aws_acm_certificate" "cert" {
  domain_name       = "dannowak.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------------
# Route 53 DNS Record for ACM Validation
# -------------------------------
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# -------------------------------
# CloudFront Distribution for Static Site
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
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021" # ✅ Fix: Upgrade TLS version
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}


# -------------------------------
# Route 53 A Record to CloudFront
# -------------------------------
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dannowak.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

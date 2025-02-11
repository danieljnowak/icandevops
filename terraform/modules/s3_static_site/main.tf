resource "aws_s3_bucket" "website" {
  bucket = "dannowak-hugo-site"
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}

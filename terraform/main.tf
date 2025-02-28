# -------------------------------
# Terraform Provider Configuration
# -------------------------------
provider "aws" {
  region = "us-east-1"
}

# -------------------------------
# Backend Configuration for Terraform State Storage
# -------------------------------
terraform {
  backend "s3" {
    bucket         = "obscuro-terraform-state-east"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks-east"
  }
}

# -------------------------------
# Module: S3 Static Site for Hugo
# -------------------------------
module "s3_static_site" {
  source                     = "./modules/s3_static_site"
  cloudfront_distribution_id = module.dns.cloudfront_distribution_id
  cloudfront_domain_name     = module.dns.cloudfront_domain_name
}

# -------------------------------
# Module: CloudFront CDN + Route 53 DNS
# -------------------------------
module "dns" {
  source = "./modules/dns"

  # Pass the necessary outputs from S3 module to the DNS module
  s3_bucket_regional_domain_name = module.s3_static_site.s3_bucket_regional_domain_name
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "obscuro-terraform-state-east"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks-east"
  }
}

module "dns" {
  source = "./modules/dns"

  s3_bucket_regional_domain_name = module.s3_static_site.s3_bucket_regional_domain_name
}

module "s3_static_site" {
  source = "./modules/s3_static_site"
}

// ---------------------------------------------------------------
// Root configuration for Terragrunt
// This file defines common settings for all environments
// ---------------------------------------------------------------

// Remote state configuration
// This configures Terragrunt to use an S3 backend for Terraform state
// with DynamoDB for state locking to prevent concurrent modifications
remote_state {
  backend = "s3"
  config = {
    bucket         = "dannowak-tfstate-${get_aws_account_id()}"  // Unique bucket per AWS account
    key            = "${path_relative_to_include()}/terraform.tfstate"  // Path-based state file organization
    region         = "us-east-1"  // Global resources region
    encrypt        = true  // Encrypt state files for security
    dynamodb_table = "dannowak-tfstate-lock"  // DynamoDB table for state locking
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

// AWS provider configuration
// Generates the AWS provider block with the correct region
// based on the environment's region.hcl file
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}

// Load environment-specific variables
// This reads the region configuration from the region.hcl file
locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region
}

// Common input variables for all modules
// These values are passed to every Terraform module
inputs = {
  project_name    = "dannowak-portfolio"  // Consistent project name for all resources
  owner           = "Dan Nowak"  // Owner tag for all resources
}

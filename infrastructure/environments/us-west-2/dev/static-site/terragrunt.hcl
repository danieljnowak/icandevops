// ---------------------------------------------------------------
// Development Static Site Infrastructure
// Terragrunt configuration for the static website hosting
// in the development environment (us-west-2)
// ---------------------------------------------------------------

// Include the root terragrunt configuration
include {
  path = find_in_parent_folders("root.hcl")
}

// Load environment-specific variables from env.hcl
locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment = local.env_vars.locals.environment
  domain_name = local.env_vars.locals.domain_name
}

// Reference the global Route 53 configuration to get zone ID
// This is needed for creating DNS records
dependency "global" {
  config_path = "../../../global/route53"
  
  // Mock outputs for plan operations without dependencies
  mock_outputs = {
    route53_zone_id = "mock-zone-id"
  }
}

// Source the static-site module from the modules directory
terraform {
  source = "../../../../modules//static-site"
}

// Module-specific input variables
inputs = {
  environment     = local.environment  // From env.hcl
  domain_name     = local.domain_name  // From env.hcl
  route53_zone_id = dependency.global.outputs.route53_zone_id  // From Route 53 module
} 
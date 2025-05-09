// ---------------------------------------------------------------
// Global Route 53 Configuration
// Sets up the primary DNS zone used by both environments
// This is a global resource managed in us-east-1
// ---------------------------------------------------------------

// Include the root terragrunt configuration
include {
  path = find_in_parent_folders("root.hcl")
}

// Source the module from the global/route53 directory
terraform {
  source = "${get_parent_terragrunt_dir()}//global/route53"
}

// No additional inputs needed for this module
// The owner variable is inherited from the root configuration
inputs = {} 
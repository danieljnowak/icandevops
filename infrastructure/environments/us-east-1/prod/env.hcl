// ---------------------------------------------------------------
// Production environment configuration
// Defines settings specific to the production environment
// including the primary domain name for the website
// ---------------------------------------------------------------

locals {
  environment = "prod"      // Environment identifier for resource naming and tagging
  domain_name = "dannowak.com"  // Primary domain for production site
} 
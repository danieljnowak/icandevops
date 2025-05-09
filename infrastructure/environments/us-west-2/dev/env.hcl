// ---------------------------------------------------------------
// Development environment configuration
// Defines settings specific to the development environment
// including the subdomain for the development website
// ---------------------------------------------------------------

locals {
  environment = "dev"           // Environment identifier for resource naming and tagging
  domain_name = "dev.dannowak.com"  // Subdomain for development site
} 
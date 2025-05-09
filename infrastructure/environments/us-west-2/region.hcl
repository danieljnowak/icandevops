// ---------------------------------------------------------------
// Region configuration for us-west-2 (Development)
// Oregon region is used for development and testing purposes
// This provides geographic redundancy from production
// ---------------------------------------------------------------

locals {
  aws_region = "us-west-2"  // Secondary region for development deployments
}

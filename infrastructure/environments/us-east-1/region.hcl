// ---------------------------------------------------------------
// Region configuration for us-east-1 (Production)
// Northern Virginia region is used for production environment
// as well as global resources like Route53 and ACM certificates
// ---------------------------------------------------------------

locals {
  aws_region = "us-east-1"  // Primary region for production deployments
}

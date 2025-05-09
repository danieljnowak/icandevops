output "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.primary.zone_id
}

output "name_servers" {
  description = "Name servers for the Route 53 zone"
  value       = aws_route53_zone.primary.name_servers
} 
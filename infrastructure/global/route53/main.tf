# Route 53 Global Configuration

# Primary hosted zone for dannowak.com
resource "aws_route53_zone" "primary" {
  name = "dannowak.com"

  tags = {
    Name  = "dannowak-com-zone"
    Owner = var.owner
  }
} 
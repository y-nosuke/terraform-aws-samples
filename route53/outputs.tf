#####################################################
# Outputs
#####################################################
output "hostzone_name_servers" {
  value = aws_route53_zone.this.name_servers
}

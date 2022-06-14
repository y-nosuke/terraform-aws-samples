#####################################################
# Outputs
#####################################################
output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "subnet_arn" {
  value = aws_subnet.this.arn
}

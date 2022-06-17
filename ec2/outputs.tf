#####################################################
# Outputs
#####################################################
output "ec2_arn" {
  value = aws_instance.this.arn
}

output "ec2_host_id" {
  value = aws_instance.this.host_id
}

output "ec2_public_ip" {
  value = aws_instance.this.public_ip
}

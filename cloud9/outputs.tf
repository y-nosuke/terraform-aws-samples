#####################################################
# Outputs
#####################################################
output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.this.id}"
}

output "coud9_user_password" {
  value = aws_iam_user_login_profile.this.password
}

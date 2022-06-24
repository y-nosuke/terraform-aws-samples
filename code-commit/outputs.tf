#####################################################
# Outputs
#####################################################
output "codecommit-clone-url-http" {
  value = aws_codecommit_repository.this.clone_url_http
}

output "codecommit-clone-url-ssh" {
  value = aws_codecommit_repository.this.clone_url_ssh
}

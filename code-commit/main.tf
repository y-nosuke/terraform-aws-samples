#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Sample = "code-commit"
    }
  }
}

terraform {
  backend "s3" {}
}

#####################################################
# Variables
#####################################################
locals {}

#####################################################
# Resources
#####################################################
resource "aws_codecommit_repository" "this" {
  repository_name = "${var.name_prefix}-repository"
  description     = "code commit repository"
  default_branch  = "main"
}

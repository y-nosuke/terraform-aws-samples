#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Sample = "route53"
    }
  }
}

terraform {
  backend "s3" {}
}

#####################################################
# Variables
#####################################################

#####################################################
# Resources
#####################################################
# Route53
resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = {
    Name = "${var.name_prefix}-hostzone"
  }
}

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
  name = "aws.physicist00.jp"

  tags = {
    Name = "sample-route53-hostzone"
  }
}

#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Sample = "vpc"
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
# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "sample-vpc"
  }
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "sample-subnet"
  }
}

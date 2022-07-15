#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Environment = title(local.environment_name)
    }
  }
}

terraform {
  backend "s3" {
  }
}

#####################################################
# Locals
#####################################################
locals {
  environment_name = "yonosuke"
}

#####################################################
# Modules
#####################################################
module "main" {
  source = "../../modules/templates/ec2-on-vpc"

  account_environment    = local.environment_name
  environment_name       = "ec2-on-vpc"
  environment_short_name = "eov"
  vpc_cidr_block         = "10.0.0.0/16"
  subnet_cidr_block      = "10.0.1.0/24"
  aws_ami_name           = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  aws_ami_owners         = ["099720109477"] # Canonical
}

#####################################################
# Resources
#####################################################

#####################################################
# Data
#####################################################
data "aws_caller_identity" "current" {}

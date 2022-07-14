#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Environment = title(var.environment_name)
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
locals {}

#####################################################
# Modules
#####################################################
module "network" {
  source = "../../../modules/network"

  name_prefix       = var.environment_short_name
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}

module "vm" {
  source = "../../../modules/vm"

  name_prefix    = var.environment_short_name
  vpc_id         = module.network.vpc_id
  subnet_id      = module.network.subnet_id
  aws_ami_name   = var.aws_ami_name
  aws_ami_owners = var.aws_ami_owners

  depends_on = [module.network]
}

#####################################################
# Resources
#####################################################

#####################################################
# Data
#####################################################
data "aws_caller_identity" "current" {}

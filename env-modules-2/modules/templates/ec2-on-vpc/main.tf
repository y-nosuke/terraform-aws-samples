#####################################################
# Locals
#####################################################
locals {}

#####################################################
# Modules
#####################################################
module "network" {
  source = "../../components/network"

  name_prefix       = var.environment_short_name
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}

module "vm" {
  source = "../../components/vm"

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

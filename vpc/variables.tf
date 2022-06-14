#####################################################
# Variables
#####################################################
variable "vpc_cidr_block" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "subnet_cidr_block" {
  type        = string
  description = "SubnetのCIDRブロック"
}

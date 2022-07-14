#####################################################
# Variables
#####################################################
# variable
variable "name_prefix" {
  type        = string
  description = "名前に付けるプレフィックス"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "subnet_cidr_block" {
  type        = string
  description = "SubnetのCIDRブロック"
}

#####################################################
# Variables
#####################################################
variable "name_prefix" {
  type        = string
  description = "名前に付けるプレフィックス"
}

variable "domain_name" {
  type        = string
  description = "DNSのドメイン名"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "subnet_1a_cidr_block" {
  type        = string
  description = "Subnet1aのCIDRブロック"
}

variable "subnet_1c_cidr_block" {
  type        = string
  description = "Subnet1cのCIDRブロック"
}

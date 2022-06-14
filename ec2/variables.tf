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

variable "nic_private_ips" {
  type        = string
  description = "ネットワークインターフェースのprivate ip"
}

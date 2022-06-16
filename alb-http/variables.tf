#####################################################
# Variables
#####################################################
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

variable "log_bucket_name" {
  type        = string
  description = "ALBのアクセスログ保存用"
}

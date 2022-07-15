#####################################################
# Variables
#####################################################
# variable
variable "account_environment" {
  description = "AWSアカウントを表す環境名"
  type        = string
}

variable "environment_name" {
  description = "AWSアカウント内の環境名"
  type        = string
}

variable "environment_short_name" {
  description = "AWSアカウント内の環境の短縮名"
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "subnet_cidr_block" {
  type        = string
  description = "SubnetのCIDRブロック"
}

variable "aws_ami_name" {
  description = "AMIの名前"
  type        = string
}

variable "aws_ami_owners" {
  description = "AMIのAWSアカウントIDのリスト"
  type        = list(string)
}

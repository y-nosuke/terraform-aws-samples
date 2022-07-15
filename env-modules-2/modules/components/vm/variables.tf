#####################################################
# Variables
#####################################################
variable "name_prefix" {
  type        = string
  description = "名前に付けるプレフィックス"
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "subnet_id" {
  description = "VPC SubnetのID"
  type        = string
}

variable "aws_ami_name" {
  description = "AMIの名前"
  type        = string
}

variable "aws_ami_owners" {
  description = "AMIのAWSアカウントIDのリスト"
  type        = list(string)
}

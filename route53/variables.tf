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

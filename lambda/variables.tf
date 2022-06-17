#####################################################
# Variables
#####################################################
variable "name_prefix" {
  type        = string
  description = "名前に付けるプレフィックス"
}

variable "lambda_file_name" {
  type        = string
  description = "lambda functionのファイル"
}

variable "lambda_file_zip_name" {
  type        = string
  description = "lambda functionのファイルをzip圧縮したファイル"
}

#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Sample = "ec2"
    }
  }
}

terraform {
  backend "s3" {}
}

#####################################################
# Variables
#####################################################
locals {
  user_data = <<USERDATA
#!/bin/bash
sudo apt update
sudo apt upgrade -y
USERDATA
}

#####################################################
# Resources
#####################################################
data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}${var.lambda_file_name}"
  output_path = "${path.module}${var.lambda_file_zip_name}"
}

# IAM
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "this" {
  filename         = data.archive_file.this.output_path
  function_name    = "${var.name_prefix}-lambda-function"
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  publish          = true
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = "python3.9"
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}

#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Sample = "cloud9"
    }
  }
}

terraform {
  backend "s3" {}
}

#####################################################
# Variables
#####################################################

#####################################################
# Resources
#####################################################
# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_cidr_block

  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.name_prefix}-subnet"
  }
}

# Internet Gateway
# route tableとともにインターネットから入ってくるために必要
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-internet-gateway"
  }
}

# Route Table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "this" {
  route_table_id = aws_route_table.this.id

  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

# Cloud9
resource "aws_cloud9_environment_ec2" "this" {
  instance_type = "t2.micro"
  name          = "${var.name_prefix}-cloud9"
  description   = "cloud9"
  owner_arn     = data.aws_iam_user.administrator.arn
  subnet_id     = aws_subnet.this.id
  image_id      = "amazonlinux-2-x86_64"
}

resource "aws_cloud9_environment_membership" "this" {
  environment_id = aws_cloud9_environment_ec2.this.id
  permissions    = "read-only"
  user_arn       = aws_iam_user.this.arn
}

data "aws_instance" "this" {
  filter {
    name   = "tag:aws:cloud9:environment"
    values = [aws_cloud9_environment_ec2.this.id]
  }
}

# IAM
data "aws_iam_user" "administrator" {
  user_name = "Administrator"
}

resource "aws_iam_user" "this" {
  name = "${var.name_prefix}-user"
  path = "/"
}

resource "aws_iam_user_policy" "this" {
  name = "cloud9-user-policy"
  user = aws_iam_user.this.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# IAM User Profile
resource "aws_iam_user_login_profile" "this" {
  user                    = aws_iam_user.this.name
  password_reset_required = true
}

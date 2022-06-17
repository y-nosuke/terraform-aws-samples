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

# EC2
data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  subnet_id                   = aws_subnet.this.id
  key_name                    = aws_key_pair.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = local.user_data

  vpc_security_group_ids = [
    aws_security_group.this.id,
  ]

  tags = {
    Name = "${var.name_prefix}-ec2"
  }

  depends_on = [aws_internet_gateway.this]
}

# Key Pair
resource "aws_key_pair" "this" {
  key_name   = "${var.name_prefix}-ssh-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security Group
resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-security-group"
  description = "security group"
  vpc_id      = aws_vpc.this.id
}

resource "aws_security_group_rule" "rule_icmp" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"

  ipv6_cidr_blocks = []
  prefix_list_ids  = []
}

resource "aws_security_group_rule" "rule_ssh" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"

  ipv6_cidr_blocks = []
  prefix_list_ids  = []
}

# インターネットへ出ていくために必要
resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

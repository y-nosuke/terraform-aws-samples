#####################################################
# Locals
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
# EC2
resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  subnet_id                   = var.subnet_id
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
  vpc_id      = var.vpc_id
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

#####################################################
# Data
#####################################################
data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = var.aws_ami_owners
}

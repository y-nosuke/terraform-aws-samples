#####################################################
# Provider
#####################################################
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Sample = "alb http"
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
sudo apt install -y nginx
USERDATA
}

#####################################################
# Resources
#####################################################
# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "sample-alb-http-vpc"
  }
}

resource "aws_subnet" "this_1a" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_1a_cidr_block

  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "sample-alb-http-subnet-1a"
  }
}

resource "aws_subnet" "this_1c" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_1c_cidr_block

  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sample-alb-http-subnet-1c"
  }
}

# Internet Gateway
# route tableとともにインターネットから入ってくるために必要
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "sample-alb-http-internet-gateway"
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


resource "aws_route_table_association" "this_1a" {
  subnet_id      = aws_subnet.this_1a.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this_1c" {
  subnet_id      = aws_subnet.this_1c.id
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
  subnet_id                   = aws_subnet.this_1a.id
  key_name                    = aws_key_pair.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = local.user_data

  vpc_security_group_ids = [
    aws_security_group.this.id,
  ]

  depends_on = [aws_internet_gateway.this]
}

# Key Pair
resource "aws_key_pair" "this" {
  key_name   = "sample-alb-http-ssh-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# ALB
resource "aws_lb" "this" {
  name               = "sample-alb-http-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.this_1a.id, aws_subnet.this_1c.id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "this" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.this.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
      message_body = "not found"
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = ["www.aws.physicist00.jp"]
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = "sample-alb-http-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id


  health_check {
    port = 80
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this.id
  port             = 80
}

# Security Group
resource "aws_security_group" "this" {
  name        = "sample-alb-http-security-group"
  description = "sample alb security group"
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

resource "aws_security_group_rule" "rule_http" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
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

resource "aws_security_group" "alb" {
  name        = "sample-alb-http-alb-security-group"
  description = "sample alb http alb security group"
  vpc_id      = aws_vpc.this.id
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_out_all" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

# Route53
data "aws_route53_zone" "this" {
  name         = "aws.physicist00.jp"
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

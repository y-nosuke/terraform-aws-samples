# 環境ごとの設定値を記述する
account_environment    = "yonosuke"
environment_name       = "ec2-on-vpc"
environment_short_name = "eov"
vpc_cidr_block         = "10.0.0.0/16"
subnet_cidr_block      = "10.0.1.0/24"
aws_ami_name           = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
aws_ami_owners         = ["099720109477"] # Canonical

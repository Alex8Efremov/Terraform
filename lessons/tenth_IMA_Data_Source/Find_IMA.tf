#------------------------------------
#
# Find Latest AMI ID of:
#      - Ubuntu 18.04
#      - Ubuntu 20.04
#      - Debian 10
#      - RedHat Enterprise Linux 8
#      - Amazon Linux 2 Kernel 5.10
#      - Windows 2019 Base
#
# Made by Aleksandr Vyskrebtcev
# 19.01.2022
#------------------------------------


provider "aws" {
  region = "ap-southeast-2"
}

data "aws_ami" "latest_ubuntu_18" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_ubuntu_20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_Debian_10" {
  owners      = ["136693071363"]
  most_recent = true
  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }
}

data "aws_ami" "latest_RedHat" {
  owners      = ["309956199498"]
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL_HA-8.4.0_HVM-20210504-x86_64-*"]
  }
}

data "aws_ami" "latest_Amazon" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_Windows_2019" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}


output "Latest_ubuntu_18_ami_id" {
  value = data.aws_ami.latest_ubuntu_18.id
}

output "Latest_ubuntu_18_ami_name" {
  value = data.aws_ami.latest_ubuntu_18.name
}

output "Latest_ubuntu_20_ami_id" {
  value = data.aws_ami.latest_ubuntu_20.id
}

output "Latest_ubuntu_20_ami_name" {
  value = data.aws_ami.latest_ubuntu_20.name
}

output "Latest_Debian_10_ami_id" {
  value = data.aws_ami.latest_Debian_10.id
}

output "Latest_Debian_10_ami_name" {
  value = data.aws_ami.latest_Debian_10.name
}

output "Latest_RedHat_ami_id" {
  value = data.aws_ami.latest_RedHat.id
}

output "Latest_RedHat_ami_name" {
  value = data.aws_ami.latest_RedHat.name
}

output "Latest_Amazon_ami_id" {
  value = data.aws_ami.latest_Amazon.id
}

output "Latest_Amazon_ami_name" {
  value = data.aws_ami.latest_Amazon.name
}

output "Latest_Windows_ami_id" {
  value = data.aws_ami.latest_Windows_2019.id
}

output "Latest_Windows_ami_name" {
  value = data.aws_ami.latest_Windows_2019.name
}

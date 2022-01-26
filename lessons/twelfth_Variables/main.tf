#====================================================
#
# The Terraform lessons
#
# Variables
#
# Made by Aleksandr Efremov
#
#====================================================


#---------------------------------------------------------------------
provider "aws" {
  region = var.name_region
}

data "aws_ami" "latest_Debian_10" {
  owners      = ["136693071363"]
  most_recent = true
  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  # tags     = var.common_tags
  tags = merge(var.common_tags, { Region = var.name_region },
  { Name = "Server IP" })
  # tags = {
  #   Name    = "Server IP"
  #   Owner   = "Efremov"
  #   Project = "DevOps"
  #   Region  = var.name_region
  # }
}

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.latest_Debian_10.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_SecGr.id]
  monitoring             = var.detailed_monitoring
  key_name               = "efremov-frankfurt"
  tags = merge(var.common_tags, { Region = var.name_region },
  { Name = "${var.common_tags["Project"]} Debian_10" })
  # tags = {
  #   Name    = "Debian_10"
  #   Owner   = "Efremov"
  #   Project = "DevOps"
  #   Region  = var.name_region
  # }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_SecGr" {
  name        = "Dynamic Security Group"
  description = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "Dynamic SG"
    Owner   = "Efremov"
    Project = "DevOps"
    Region  = var.name_region
  }
}

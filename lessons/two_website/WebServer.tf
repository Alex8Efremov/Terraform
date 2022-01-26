#---------------------------------
# My Terraform
#
# Build WebServer during Bootsrap
#
# made by Aleksandr Vyskrebtcev
#---------------------------------

provider "aws" {
  region = "eu-central-1"
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-05cafdf7c9f772ad2" # Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_name_SecGr.id]
  user_data              = <<E0F
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ip4`
echo "<h2>WebServer with IP: $myip</h2><Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkonfig httpd on
E0F

  tags = {
    Name    = "Linux_Amazon"
    Owner   = "Aleksandr V"
    Project = "Terraform_Lessons_two"
  }
}


resource "aws_security_group" "my_name_SecGr" {
  name        = "WebServer Security Group"
  description = "My First Security Group"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "Linux_Amazon"
    Owner   = "Aleksandr V"
    Project = "Terraform_Lessons_two"
  }
}

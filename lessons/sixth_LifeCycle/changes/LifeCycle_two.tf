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
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Aleksandr",
    l_name = "Vys",
    names  = ["Vasya", "Olya", "Petya", "Alis", "John"]
  })

  tags = {
    Name    = "Linux_Amazon"
    Owner   = "Aleksandr V"
    Project = "Terraform_Lessons_two"
  }

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }

}




resource "aws_security_group" "my_name_SecGr" {
  name        = "Dynamic Security Group"
  description = "Dynamic Security Group"


  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1542", "2323", "9093"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.86.108.0/24"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "Dynamic SG Linux_Amazon"
    Owner   = "Aleksandr V"
    Project = "Terraform_Lessons_two"
  }
}

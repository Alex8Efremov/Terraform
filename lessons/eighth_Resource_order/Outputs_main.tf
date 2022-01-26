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
  vpc_security_group_ids = [aws_security_group.my_name_SecGr.id] # id security_group


  tags = {
    Name = "Linux_Amazon"
  }
  depends_on = [aws_instance.my_app]
}
resource "aws_instance" "my_db" {
  ami                    = "ami-05cafdf7c9f772ad2" # Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_name_SecGr.id] # id security_group


  tags = {
    Name = "Linux_Amazon_DataBase"
  }
}
resource "aws_instance" "my_app" {
  ami                    = "ami-05cafdf7c9f772ad2" # Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_name_SecGr.id] # id security_group


  tags = {
    Name = "Linux_Amazon_Application"
  }
  depends_on = [aws_instance.my_db]
}
resource "aws_security_group" "my_name_SecGr" {
  name        = "Dynamic Security Group"
  description = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    Name  = "Dynamic SG Linux_Amazon"
    Owner = "Aleksandr V"
  }
}

# recommendation: You'll need to make more outputs of important things

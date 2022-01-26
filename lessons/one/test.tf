provider "aws" {
}

resource "aws_instance" "Linux_Ubuntu" {
  count         = 2
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

  tags = {
    Name    = "Linux_Ubuntu_20"
    Owner   = "Aleksandr V"
    Project = "Terraform_Lessons"
  }

}

resource "aws_instance" "Linux_RedHat" {
  count         = 1
  ami           = "ami-06ec8443c2a35b0ba"
  instance_type = "t2.micro"

  tags = {
    Name    = "Linux_RedHat"
    Owner   = "Aleksandr V"
    Project = "Terraform_Lessons"
  }

}

resource "aws_instance" "Linux_Debian" {
  count         = 1
  ami           = "ami-0245697ee3e07e755"
  instance_type = "t2.micro"

  tags = {
    Name    = "Linux_Debian"
    Owner   = "Aleksandr V"
    Project = "Terraform_Lessons"
  }

}

#=========================================================
#
# Provision Highly Available Web in any Region Default VPC
# Create:
#       - Security Group for Web Server
#       - Launch Configuration with Auto AMI Lookup
#       - Auto Scaling Group using 2 Availability Zones
#       - Classic Load Balancer in 2 Availability Zones
#
# Made by Aleksandr Vyskrebtcev 20-January-2022
#
#=========================================================


provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_Debian_10" {
  owners      = ["136693071363"]
  most_recent = true
  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }
}

output "Latest_Debian_10_ami_id" {
  value = data.aws_ami.latest_Debian_10.id
}

#-------------------------Security Group-------------------------------
resource "aws_security_group" "my_name_SecGr" {
  name        = "Dynamic Security Group"
  description = "My First Security Group"

  dynamic "ingress" {
    for_each = ["80", "443"]
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
    Name    = "Dynamic Security Group"
    Owner   = "Aleksandr V"
    Project = "Terraform_Zero_DownTime"
  }
}

#--------------------------Launch Configuration------------------------

resource "aws_launch_configuration" "web" {
  //  name            = "WebServer-Highly-Available-LC"
  name_prefix     = "WebServer-Highly-Available-LC-" # to change name
  image_id        = data.aws_ami.latest_Debian_10.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_name_SecGr.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

#--------------------------Auto Scaling Group--------------------------

resource "aws_autoscaling_group" "web" {
  #  name                 = "WebServer-Highly-Available-ASG"
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  max_size             = 2
  min_size             = 2
  min_elb_capacity     = 2     # health_check
  health_check_type    = "ELB" # ELB == ping to page; or EC2
  vpc_zone_identifier = [aws_default_subnet.subnet_1.id,
  aws_default_subnet.subnet_2.id]
  load_balancers = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name    = "WebServer in ASG"
      Owner   = "Efremov"
      TagName = "TagValue"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  # tags = [
  #   {
  #     key                 = "Name"
  #     value               = "WebServer-in-ASG"
  #     propagate_at_launch = true
  #   },
  #   {
  #     key                 = "Owner"
  #     value               = "Aleksandr"
  #     propagate_at_launch = true
  #   },
  # ]
}
#--------------------------E Load Balancer-----------------------------

resource "aws_elb" "web" {
  name = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0],
  data.aws_availability_zones.available.names[1]]
  security_groups = [aws_security_group.my_name_SecGr.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 20
  }
  tags = {
    Name = "WebServer-Highly-Available-ELB"
  }
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#--------------------------------------------------------------------
output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}

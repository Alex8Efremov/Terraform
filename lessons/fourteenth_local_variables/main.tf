#=============================================
# The Terraform Lessons
#
# Local Variables
#
# Made by Aleksandr Efremov
#=============================================

provider "aws" {
  region = "ca-central-1"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}


locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_name      = "--> ${var.owner} owner of ${var.project_name}"
}

locals {
  country  = "Canada"
  city     = "Someone"
  az_list  = join(";", data.aws_availability_zones.available.names)
  region   = data.aws_region.current.description
  location = "In ${local.region} there are AZ: ${local.az_list}"
}

resource "aws_eip" "my_static_ip" {
  # instance = aws_instance.my_server.id
  tags = {
    Name          = "Static IP"
    Owner         = var.owner
    Project       = local.full_project_name
    Project_owner = local.project_name
    City          = local.city
    region_AZs    = local.location
  }
}

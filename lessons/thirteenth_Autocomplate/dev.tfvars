# ===========================================
# Auto Fill up parameters for DEV
# File can be names as:
#   terraform.tfvars
#   prod.auto.tfvars
#   dev.tfvars if run via command line


name_region   = "us-east-1"
instance_type = "t3.micro"

common_tags = {
  Owner      = "Efremov_one"
  Project    = "DevOps"
  Enviroment = "Dev"
}

allow_ports = ["2323", "443", "80", "22"]

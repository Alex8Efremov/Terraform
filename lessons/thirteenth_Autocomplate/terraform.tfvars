# ===========================================
# Auto Fill up parameters for DEV
# File can be names as:
#   terraform.tfvars
#   prod.auto.tfvars
#   dev.auro.tfvars


name_region   = "sa-east-1"
instance_type = "t3.micro"

common_tags = {
  Owner      = "Efremov_one"
  Project    = "DevOps"
  Enviroment = "Dev"
}

allow_ports = ["2323", "443", "80", "22"]

# ===========================================
# Auto Fill up parameters for PROD
# File can be names as:
#   terraform.tfvars
#   prod.auto.tfvars
#   dev.auro.tfvars


name_region   = "eu-central-1"
instance_type = "t2.micro"

common_tags = {
  Owner      = "Efremov_two"
  Project    = "DevOps"
  Enviroment = "Prod"
}

allow_ports = ["443", "80", "22"]

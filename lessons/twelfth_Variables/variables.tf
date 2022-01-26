
# type == string by default
variable "name_region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Enter Instance Type"
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "The list of Ports to open for Server"
  type        = list(any)
  default     = ["80", "22", "443", "8080"]
}

variable "detailed_monitoring" {
  type    = bool
  default = false
}


variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
    Owner      = "Efremov"
    Project    = "DevOps"
    Enviroment = "development"
    # Region     = var.name_region
  }
}

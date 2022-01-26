provider "aws" {
  region = "eu-central-1"
}

# if need change variables
variable "name" {
  default = "vasya"
}

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&"
  # если поменяется name пароль сменяется
  keepers = {
    keeper1 = var.name
    // keeper2 = var.something
  }

}

# сохраняем пароль
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master Password for RDS MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
  # value = "mypassword!@#$" # we can use this
}

# берем пароль
data "aws_ssm_parameter" "my_rds_password" {
  name = "/prod/mysql"

  depends_on = [aws_ssm_parameter.rds_password]
}

output "rds_password" {
  value     = data.aws_ssm_parameter.my_rds_password.value
  sensitive = true

  #depends_on = [data.aws_ssm_parameter.my_rds_password]
}


# используем пароль
resource "aws_db_instance" "default" {
  identifier             = "db-rds"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "Efremov"
  username               = "administrator"
  password               = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  apply_immediately      = true
  vpc_security_group_ids = ["sg-0ec16fb7fc70b1e73", "sg-0bbb0a65503f1fd6f", "sg-06964d0ccaab0cce6"]
}

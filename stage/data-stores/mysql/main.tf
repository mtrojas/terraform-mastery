terraform {
  backend "s3" {
    key = "stage/data-stores/mysql/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

# Passing the variable from the child module
variable "db_password" {}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  cluster_name = "stage"
  db_password  = var.db_password

}

# Accessing Child Module Outputs
output "address" {
  value = module.mysql.address
}

output "port" {
  value = module.mysql.address
}

terraform {
  backend "s3" {
    key = "prod/data-stores/mysql/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Passing the variable from the child module
variable "db_password" {}

module "mysql" {
  source = "github.com/mtrojas/terraform-mastery-modules//data-stores/mysql?ref=v0.0.1"

  cluster_name = "prod"
  db_password  = var.db_password

}

# Accessing Child Module Outputs
output "address" {
  value = module.mysql.address
}

output "port" {
  value = module.mysql.port
}

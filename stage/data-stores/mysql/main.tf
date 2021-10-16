terraform {
  required_providers {
    # Allow any 3.x version of the AWS provider
    aws = {
      version = "~> 3.0"
    }
  }

  backend "s3" {
    key = "stage/data-stores/mysql/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "mysql" {
  source = "github.com/mtrojas/terraform-mastery-modules//data-stores/mysql?ref=v0.0.12"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

}

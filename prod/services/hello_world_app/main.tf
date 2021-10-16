terraform {
  required_providers {
    # Allow any 3.x version of the AWS provider
    aws = {
      version = "~> 3.0"
    }
  }

  backend "s3" {
    key = "prod/services/hello-world-app/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "hello_world_app" {
  source = "github.com/mtrojas/terraform-mastery-modules//services/hello-world-app?ref=v0.0.13"

  ami         = "ami-0747bdcabd34c712a"
  server_text = "My Production Deployment v0.0.1"
  environment = "production"

  db_remote_state_bucket = "terraform-mastery-remote-backend"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type      = "m4.large"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Owner       = "team-devops"
    DeployedBy  = "terraform"
    Environment = "production"
  }
}


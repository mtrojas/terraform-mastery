terraform {
  required_providers {
    # Allow any 3.x version of the AWS provider
    aws = {
      version = "~> 3.0"
    }
  }
  backend "s3" {
    key = "stage/services/hello-world-app/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "hello_world_app" {
  source = "github.com/mtrojas/terraform-mastery-modules//services/hello-world-app?ref=v0.0.15"

  server_text = var.server_text
  environment = var.environment

  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false

  custom_tags = {
    Owner       = "team-devops"
    DeployedBy  = "terraform"
    Environment = "staging"
  }
}

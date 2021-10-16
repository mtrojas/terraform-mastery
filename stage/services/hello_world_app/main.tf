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
  source = "github.com/mtrojas/terraform-mastery-modules//services/hello-world-app?ref=v0.0.13"

  server_text = "My new text to deploy v0.0.4"
  environment = "staging"

  db_remote_state_bucket = "terraform-mastery-remote-backend"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

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

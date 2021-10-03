terraform {
  backend "s3" {
    key = "stage/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "github.com/mtrojas/terraform-mastery-modules//services/webserver-cluster?ref=v0.0.6"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "terraform-mastery-remote-backend"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  ami                  = "ami-0c55b159cbfafe1f0"
  instance_type        = "t2.micro"
  min_size             = 2
  max_size             = 2
  enable_autoscaling   = false
  enable_new_user_data = true

  custom_tags = {
    Owner       = "team-devops"
    DeployedBy  = "terraform"
    Environment = "staging"
  }
}

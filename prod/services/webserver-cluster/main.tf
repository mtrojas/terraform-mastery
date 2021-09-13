terraform {
  backend "s3" {
    key = "prod/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "github.com/mtrojas/terraform-mastery-modules//services/webserver-cluster?ref=v0.0.2"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-mastery-remote-backend"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  ami           = "ami-0747bdcabd34c712a"
  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10

  custom_tags = {
    Owner      = "team-devops"
    DeployedBy = "terraform"
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}


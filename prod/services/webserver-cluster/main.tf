terraform {
  backend "s3" {
    key = "prod/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-prod"
  ami                    = "ami-0747bdcabd34c712a"
  db_remote_state_bucket = "terraform-mastery-remote-backend"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
}

# Accessing Child Module Outputs
output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

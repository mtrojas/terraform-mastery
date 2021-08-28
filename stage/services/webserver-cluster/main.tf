terraform {
  backend "s3" {
    key = "stage/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-stage"
  ami                    = "ami-0c55b159cbfafe1f0"
  db_remote_state_bucket = "terraform-mastery-remote-backend"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}

# Accessing Child Module Outputs
output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

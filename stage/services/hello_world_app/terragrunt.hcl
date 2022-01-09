# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source = "github.com/mtrojas/terraform-mastery-modules//services/hello-world-app?ref=v0.0.17"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-2"
}
EOF
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../data-stores/mysql"]
}

# Indicate the input values to use for the variables of the module.
inputs = {
  environment = "staging"

  min_size = 2
  max_size = 2

  db_remote_state_bucket = "terraform-mastery-remote-backend"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  enable_autoscaling = false

  custom_tags = {
    Owner       = "team-devops"
    DeployedBy  = "terraform"
    Environment = "staging"
  }
}

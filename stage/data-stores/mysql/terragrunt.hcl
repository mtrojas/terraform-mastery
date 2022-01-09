# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source = "github.com/mtrojas/terraform-mastery-modules//data-stores/mysql?ref=v0.0.17"
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
# Indicate the input values to use for the variables of the module.
inputs = {
  db_name     = "example_stage"
  db_username = "maite"

  # Set the password using the TF_VAR_db_password environment variable
}

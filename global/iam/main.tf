terraform {
  backend "s3" {
    key = "global/iam/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "tf_users" {
  for_each = toset(var.user_names)
  name     = each.value
}



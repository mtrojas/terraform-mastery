remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-mastery-remote-backend"

    key            = "stage/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-mastery-locks"
  }
}



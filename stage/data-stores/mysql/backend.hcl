bucket         = "terraform-mastery-remote-backend"
key            = "stage/data-stores/mysql/terraform.tfstate"
region         = "us-east-2"
dynamodb_table = "terraform-mastery-locks"
encrypt        = true

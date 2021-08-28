resource "aws_db_instance" "db" {
  identifier_prefix = "${var.cluster_name}-db-servers"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "test"
  username          = "admin"
  # Using the following config to destroy without a final snapshot
  skip_final_snapshot = true
  apply_immediately   = true
  # Could not make it work with AWS Secrets Manager, every time got weird errors regarding the password stored:
  # Error: Error creating DB Instance: InvalidParameterValue: The parameter MasterUserPassword is not a valid password. Only printable ASCII characters besides '/', '@', '"', ' ' may be used.
  # Error: Error creating DB Instance: InvalidParameterValue: The parameter MasterUserPassword is not a valid password because it is longer than 41 characters.
  # Ended up using the environment variable TF_VAR
  password = var.db_password
}



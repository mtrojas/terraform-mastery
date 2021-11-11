# Provisioners examples
# The following code is not related to the overall project
terraform {
  backend "s3" {
    key = "global/provisioners/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

# local-exec provisioner
resource "aws_instance" "test_local-exec" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo \"Hello, World from $(uname -smp)\""
  }
}

# remote-exec provisioner
resource "aws_security_group" "sg_remote-exec" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["91.250.240.248/32"]
  }
}

# To make this example easy to try out, we generate a private key in Terraform.
# In real-world usage, I manage SSH keys outside of Terraform.
resource "tls_private_key" "pk_remote-exec" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.pk_remote-exec.public_key_openssh
}

resource "aws_instance" "test_remote-exec" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_remote-exec.id]
  key_name               = aws_key_pair.generated_key.key_name

  provisioner "remote-exec" {
    inline = ["echo \"Hello, World from $(uname -smp)\""]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.pk_remote-exec.private_key_pem
  }
}

# Provisioners with null_resource
resource "null_resource" "test" {
  # Use UUID to force this null_resource to be recreated on every
  # call to 'terraform apply'
  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    command = "echo \"Hello, World from $(uname -smp)\""
  }
}

# External data source
data "external" "echo" {
  program = ["bash", "-c", "cat /dev/stdin"]

  query = {
    foo = "bar"
  }
}

output "echo" {
  value = data.external.echo.result
}

output "echo_foo" {
  value = data.external.echo.result.foo
}

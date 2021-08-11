terraform {
  backend "s3" {
    key = "stage/services/webserver-cluster/terraform.tfstate"
  }
}


provider "aws" {
  region = "us-east-2"
}

resource "aws_launch_configuration" "servers" {
  image_id        = "ami-0c55b159cbfafe1f0"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.id]
  user_data       = <<-EOF
  #!/bin/bash
  echo "Hello, World" > index.html
  nohup busybox httpd -f -p "${var.server_port}" &
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-servers" {
  launch_configuration = aws_launch_configuration.servers.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  target_group_arns = [aws_lb_target_group.tg-servers.arn]
  health_check_type = "ELB"

  min_size = 3
  max_size = 5

  tag {
    key                 = "Name"
    value               = "asg-servers"
    propagate_at_launch = true
  }
}

resource "aws_lb" "alb-servers" {
  name               = "alb-servers"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.sg-alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb-servers.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "alb-listener-rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-servers.arn
  }

}

resource "aws_lb_target_group" "tg-servers" {
  name     = "tg-servers"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "sg-alb" {
  name = "secgroup-alb"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "sg" {
  name = "secgroup-servers"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}




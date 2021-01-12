provider "aws" {
region = "eu-west-2"
}

resource "aws_instance" "example" {
  ami = "ami-0ff4c8fb495a5a50d"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2Instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags = {
    Name = "UbuntuExample"
  }
}

resource "aws_security_group" "ec2Instance" {
  name = "collinsongroup-example"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "launchConfExample" {
  image_id        = "ami-0ff4c8fb495a5a50d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2Instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "atuoScaleExample" {
  launch_configuration = aws_launch_configuration.launchConfExample.id
  availability_zones = data.aws_availability_zones.all.names

  min_size = 2
  max_size = 3

  load_balancers = [aws_elb.example.name]

  tag {
    key                 = "Name"
    value               = "collinsongroup-asg-example"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "example" {
  name               = "collinsongroup-asg-example"
  availability_zones = data.aws_availability_zones.all.names
  security_groups = [aws_security_group.elbExample.id]

  listener {
    instance_port = var.server_port
    instance_protocol = "http"
    lb_port = var.elb_port
    lb_protocol = "http"
  }
}

resource "aws_security_group" "elbExample" {
  name = "collinsongroup-elb-example"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
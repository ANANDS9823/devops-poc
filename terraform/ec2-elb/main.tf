provider "aws" {
  region = "ap-south-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}


resource "aws_ecr_repository" "app_repo" {
  name         = "devops-repo"
  force_delete = true

  image_tag_mutability = "MUTABLE"  # or "IMMUTABLE"

  tags = {
    Environment = "dev"
    Project     = "devops-repo"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow HTTP traffic"
  vpc_id      = "vpc-06d5e46db3782bb15"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-01b6d88af12965bb6"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.app_sg.name]
  key_name      = "devops-key"
  
  user_data     = file("user_data.sh")

  tags = {
    Name = "AppServer"
  }
}

resource "aws_elb" "web_elb" {
  name               = "web-elb"
  availability_zones = var.availability_zones
  security_groups    = [aws_security_group.app_sg.name]
  instances          = [var.ec2_instance_id]

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:5000/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "WebELB"
  }
}


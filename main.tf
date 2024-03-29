terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key Pair that need to be associated with EC2 Instance"
  type        = string
  default     = "arrowlevent"       # write yours
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "arrow_roman-numerals_instance"
}

variable "enable_public_ip" {
  description = "Enable public IP address"
  type        = bool
  default     = true
}


resource "aws_instance" "arrow_roman-numerals_ec2" {
  ami                         = "ami-06aa3f7caf3a30282"         # Ubuntu 20.04  ; maybe you need to change because it may not be up-to-date
  instance_type               = var.instance_type
  key_name                    = var.instance_keypair
  vpc_security_group_ids      = [aws_security_group.arrow.id]
  associate_public_ip_address = var.enable_public_ip
  subnet_id                   = "subnet-01184bdfee33d5c74"      # us-east-1a # write yours
  user_data                   = file("${path.module}/userdata.sh")
  tags = {
    Name = var.instance_name
  }
}


resource "aws_security_group" "arrow" {
  name        = "arrow-secgrp"
  description = "arrow-secgrp enable SSH-HTTP for roman-numerals project"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "arrow_roman-numerals_secgrp"
  }
}


output "roman-numerals_instance_public-ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.arrow_roman-numerals_ec2.public_ip
}

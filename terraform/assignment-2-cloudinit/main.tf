provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "web_sg" {
  name        = "cloudinit-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "cloudinit_server" { 
    ami = var.ami 
    instance_type = var.instance_type
    key_name = "wordpress-key"
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    user_data = file("${path.module}/cloud-init.yaml")
    tags = {
    Name = "terraform-cloudinit"
  }
}

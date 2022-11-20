provider "aws" {
  region = var.aws_region
  access_key = ""
  secret_key = ""
}

# genrate key ##

resource "aws_key_pair" "lab-key" {
  key_name   = "lab-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create local file
resource "local_file" "TF-key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "tfkey"
  
}

# Create security group with firewall rules

resource "aws_security_group" "TF-SG" {
  name        = var.security_group
  description = "Allow inbound & outbound firewall traffic"
  vpc_id = aws_vpc.lab-vpc.id


  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound allow all traffic from any to any ipv4
 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}


# S3 bucket
resource "aws_s3_bucket" "lb_logs" {
  bucket = "my-tf-test-bucket"

}

resource "aws_s3_bucket_acl" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  acl    = "private"
}


# application loadbalancer

resource "aws_lb" "aws_alb_tf" {
  name               = "aws_alb_tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.TF-SG.id] ## NTC [aws_security_group.TF-SG."name or id"]
  subnets            = [for subnet in aws_subnet.public : subnet.id] ## need subnet and varible

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "lab"
  }
}

# EC2 Instances
resource "aws_instance" "myInstance" {
  ami = var.ami_id
  count = var.count_instance # "2"
  key_name = var.key_name
  instance_type = var.instance_type
  security_groups = [aws_security_group.TF-SG.name]
  tags= {
    Name = var.tag_name
    Env = "lab"
  }

# Install nginx  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]

  }
}





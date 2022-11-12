provider "aws" {
  access_key = "ddddddddddd"
  secret_key = "rrrrrrrrrrr"
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}

#Create security group with firewall rules
resource "aws_security_group" "aws_security_group_rule" {
  name        = var.security_group
  description = "security group for apps"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from nginx server
 #Egress means traffic that’s leaving from inside the private network out to the public internet.
  egress {
    from_port   = 80 # should be any port NTC
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}

# EC2 Instances
resource "aws_instance" "myInstance" {
  ami = var.ami_id
  count = var.count_instance # "2"
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.aws_security_group_rule.id] # NTC the sg-123456 number
  iassociate_public_ip_address = true # Auto-assign public IP "enable"
  tags= {
    Name = var.tag_name
    Env = "staging"
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

# S3 bucket
resource "aws_s3_bucket" "lb_logs" {
  bucket = "my-tf-test-bucket"

}

resource "aws_s3_bucket_acl" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  acl    = "private"
}


# loadbalancer

resource "aws_lb" "aws_elb_tf" {
  name               = "aws_elb_tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform_aws_security_group_rule.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "staging"
  }
}

# OUTPUT to print to the console the ELB public DNS

output "ELB public DNS" {
  value = aws_lb.aws_elb_tf.public_dns
}

# # Network Load Balancer
# resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = [for subnet in aws_subnet.public : subnet.id]

#   enable_deletion_protection = true

#   tags = {
#     Environment = "production"
#   }
# }


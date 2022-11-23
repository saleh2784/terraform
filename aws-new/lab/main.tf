############################################################################
                                  ## VPC ##
############################################################################

data "aws_vpc" "default" {
  default = true
}

############################################################################
                                  ## Subnet ##
############################################################################
# Create Subnet

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

############################################################################
                                  ## alb ##
############################################################################

resource "aws_lb" "external-lb" {
  name                             = "External-LB"
  load_balancer_type               = "application"
  internal                         = false
  enable_cross_zone_load_balancing = "true"
  security_groups    = [aws_security_group.TF-SG.id]

  subnets            = data.aws_subnets.default.ids
}
############################################################################
                            ## auto_scaling_group ##
############################################################################

resource "aws_autoscaling_group" "asg" {
  name                 = "asg"
  launch_configuration = aws_launch_configuration.My_Launch_Configuration.id
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  availability_zones = ["us-east-1a", "us-east-1b"]
  max_size             = "2"
  min_size             = "1"
  desired_capacity     = "2"
  health_check_grace_period = "300"
}

############################################################################
                        ## lb_listener_rule ##
############################################################################

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

############################################################################
                                ## lb_listener ##
############################################################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.external-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}


############################################################################
                            ## lb_target_group ##
############################################################################

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = 80
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

############################################################################
                                ## eip ##
############################################################################

resource "aws_eip" "lb" {
  instance = aws_instance.my-ec2-instance.id
  vpc      = true
}

############################################################################
                            ## Security Group ##
############################################################################

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




############################################################################
                            ## genrate key ##
############################################################################



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



############################################################################
                            ## EC2 Instances ##
############################################################################

# EC2 Instances
resource "aws_instance" "my-ec2-instance" {
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

############################################################################
        ## OUTPUT to print to the console the ELB public DNS & IP ##
############################################################################


# OUTPUT to print to the console the ELB public DNS

output "ELB public DNS" {
  value = aws_lb.aws_alb_tf.public_dns
}


output "server_public_ip" {
  value = aws_eip.one.public_ip
}

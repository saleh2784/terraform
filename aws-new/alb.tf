# loadbalancer

resource "aws_lb" "aws_lb_tf" {
  name               = "aws_elb_tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lab-sg-2022.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id] ## need subnet and varible

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
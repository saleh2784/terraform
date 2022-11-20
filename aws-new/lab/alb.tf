resource "aws_lb" "external-lb" {
  name                             = "External-LB"
  load_balancer_type               = "application"
  internal                         = false
  enable_cross_zone_load_balancing = "true"
  security_groups    = [aws_security_group.TF-SG.id]

  subnets            = data.aws_subnets.default.ids
}
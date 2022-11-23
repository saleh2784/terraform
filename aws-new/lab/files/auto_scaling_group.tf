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
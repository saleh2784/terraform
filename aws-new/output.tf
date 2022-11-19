# OUTPUT to print to the console the ELB public DNS

output "ELB public DNS" {
  value = aws_lb.aws_lb_tf.public_dns
}
# OUTPUT to print to the console the ELB public DNS

output "ELB public DNS" {
  value = aws_lb.aws_alb_tf.public_dns
}


output "server_public_ip" {
  value = aws_eip.one.public_ip
}

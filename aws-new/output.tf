# OUTPUT to print to the console the ELB public DNS

output "ELB public DNS" {
  value = aws_lb.aws_alb_tf.public_dns
}


/* output "ec2_global_ips" {
  value = "${aws_instance.myInstance.*.public_ip}"
} */
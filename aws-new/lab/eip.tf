resource "aws_eip" "lb" {
  instance = aws_instance.my-ec2-instance.id
  vpc      = true
}

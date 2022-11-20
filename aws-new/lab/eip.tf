resource "aws_eip" "lb" {
  instance = aws_instance.myInstance.id
  vpc      = true
}

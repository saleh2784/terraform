#Create security group with firewall rules

resource "aws_security_group" "lab-sg-2022" {
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
    to_port     = 80 # should be any port NTC
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}

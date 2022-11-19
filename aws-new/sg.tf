#Create security group with firewall rules

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

 # outbound allow all traffic from any to any ipv4 & ipv6
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

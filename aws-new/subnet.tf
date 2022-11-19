# 4. create subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "lab-subnet-1"
  }
}

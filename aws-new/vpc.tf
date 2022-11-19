# create vpc

resource "aws_vpc" "lab-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "lab-vpc"
  }
}

# create subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "lab-subnet"
  }
}

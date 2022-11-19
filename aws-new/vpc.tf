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
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "lab-subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "lab-subnet-2"
  }
}


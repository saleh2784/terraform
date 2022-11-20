variable "aws_region" {
       description = "The AWS region to create things in." 
       default     = "us-east-2" 
}

variable "key_name" { 
    description = " SSH keys to connect to ec2 instance" 
    default     =  "TF_key" 
}

variable "instance_type" { 
    description = "instance type for ec2" 
    default     =  "t2.micro"
}

variable "security_group" { 
    description = "Name of security group" 
    default     = "TF-SG" 
}

variable "tag_name" { 
    description = "Tag Name of for Ec2 instance" 
    default     = "my-ec2-instance" 
} 
variable "ami_id" { 
    description = "Amazon Linux 2 EC2 instance" 
    default     = "ami-070b208e993b59cea" 
}
variable "count_instance" { 
    description = "count_instance" 
    default     = "2" 
}

variable "subnet-cidr-block" { 
    description = "subnet-cidr-block" 
    default     = "10.0.1.0/24" 
}

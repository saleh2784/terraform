# EC2 Instances
resource "aws_instance" "myInstance" {
  ami = var.ami_id
  count = var.count_instance # "2"
  key_name = var.key_name
  instance_type = var.instance_type
  # user_data = file("init.sh")
  # vpc_security_group_ids = [aws_security_group.lab-sg-2022.id] 
  security_groups = [aws_security_group.lab-sg-2022.name]
  iassociate_public_ip_address = true # Auto-assign public IP "enable"
  tags= {
    Name = var.tag_name
    Env = "lab"
  }

# Install nginx  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]

  }
}
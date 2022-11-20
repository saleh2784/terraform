# EC2 Instances

resource "aws_instance" "my-ec2-instance" {
  ami = var.ami_id
  count = var.count_instance # "2"
  key_name = var.key_name
  instance_type = var.instance_type
  availability_zone = "us-east-1a"
  user_data = file("init.sh")    ## run init.sh script if required instead of the provisioner "remote-exec"
  security_groups = [aws_security_group.TF-SG.name]
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  iassociate_public_ip_address = true # Auto-assign public IP "enable"
  tags= {
    Name = var.tag_name
    Env = "lab"
  }
}

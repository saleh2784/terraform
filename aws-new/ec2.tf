# EC2 Instances
resource "aws_instance" "myInstance" {
  ami = var.ami_id
  count = var.count_instance # "2"
  key_name = var.key_name
  instance_type = var.instance_type
  ## run init.sh script if required instead of the provisioner "remote-exec"
  # user_data = file("init.sh") 
  security_groups = [aws_security_group.TF-SG.name]
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
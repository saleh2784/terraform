# terraform

## terraform commands ##

# terraform init 
# terraform fmt
# terraform valdiate
# terraform plan
# terraform apply --auto-approve
# terraform destroy
# terraform state show _________ for example = aws_internet_gateway.gw OR aws_vpc.lab-vpc
# terraform destroy -target aws_instance.my-ec2-instance  # delete specific resource


###################################

# create vpc
# create subnet
# create GW
# create route-table
# create eip
# create NIC
# create ec2 instance
# create security group
# genrate key 
#create LB application 
# elb
# auto_scaling_group
# lb_listener_rule
# lb_listener
# lb_target_group

###################################

how to run it :

# git clone https://github.com/saleh2784/terraform.git

# updated the access key & secret key in provider.tf 

# terraform init

# terraform valdiate

# terraform plan

# terraform apply --auto-approve

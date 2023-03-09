
# Create VPC Terraform Module

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

 # VPC Basic Details

name = "vpc-dev"
cidr = "10.0.0.0/16"
azs                 = ["us-east-1a", "us-east-1b"]
private_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets      = ["10.0.101.0/24", "10.0.102.0/24"]
enable_nat_gateway = true
single_nat_gateway = true # if you want a single or multiple NAT gatewate, it should be false in Production 

 # VPC DNS Parameters
default_vpc_enable_dns_hostnames = true
default_vpc_enable_dns_support  = true


#Database Subnets
database_subnets    = ["10.0.151.0/24", "10.0.152.0/24"]
create_database_subnet_group = true
create_database_subnet_route_table = true

/*# this is if you want your DB to be publicly accessible via d internet, d defualt is false, you can make it true if you want
#create_database_nat_gateway_route = true
#create_database_internet_gateway_route = true
*/


public_subnet_tags = {
  Type = "public-subnet"
}

private_subnet_tags = {
  Type = "private-subnet"
}

database_subnet_tags = {
  Type = "database-subnet"
}

tags = {
  Owner = "opeyemi"
  Enviroment = "dev"
}

vpc_tags = {
  Name = "vpc-dev"
}

}




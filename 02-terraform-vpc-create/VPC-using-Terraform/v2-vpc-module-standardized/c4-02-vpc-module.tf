
# Create VPC Terraform Module

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

 # VPC Basic Details

name = "${local.name}-${var.vpc_name}"
cidr = var.vpc_cidr_block
azs                 = var.vpc_availability_zones
private_subnets     = var.vpc_private_subnets
public_subnets      = var.vpc_public_subnets
enable_nat_gateway = var.vpc_enable_nat_gateway
single_nat_gateway = var.vpc_single_nat_gateway # if you want a single or multiple NAT gatewate, it should be false in Production 

 # VPC DNS Parameters
default_vpc_enable_dns_hostnames = true
default_vpc_enable_dns_support  = true


#Database Subnets
database_subnets    = var.vpc_database_subnets
create_database_subnet_group = var.vpc_create_database_subnet_group
create_database_subnet_route_table = var.vpc_create_database_subnet_route_table

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

tags = local.common_tags

vpc_tags = local.common_tags

}




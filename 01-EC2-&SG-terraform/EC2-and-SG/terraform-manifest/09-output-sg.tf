#Public bastion SG output

output "public-bastion-security_group_id" {
  description = "The ID of the security group"
  value       = module.public-bastion-SG.security_group_id
}

output "public-bastion-security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.public-bastion-SG.security_group_vpc_id
}


output "public-bastion-security_group_name" {
  description = "The name of the security group"
  value       = module.public-bastion-SG.security_group_name
}


# Private SG output 

output "private-security_group_id" {
  description = "The ID of the security group"
  value       = module.private-SG.security_group_id
}

output "private-security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.private-SG.security_group_vpc_id
}


output "private-security_group_name" {
  description = "The name of the security group"
  value       = module.private-SG.security_group_name
}

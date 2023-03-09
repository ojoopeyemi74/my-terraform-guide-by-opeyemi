# Ec2 Public output
output "ec2-public-id" {
  description = "List of IDs of instances"
  value       = module.bastion-ec2-instance.id
}

output "ec2-public-ip" {
  description = "List of public DNS names assigned to the instances"
  value       = module.bastion-ec2-instance.public_ip
}

# Ec2 Private output

output "ec2-private-ip-1" {
  value = [for instance in module.private-ec2-instance: instance.private_ip]
}

output "ec2-private-id-1" {
  value = [for instance in module.private-ec2-instance: instance.id]
}


# Ec2 Private output

/*
output "ec2-private-id" {
  description = "List of IDs of instances"
  value       = module.private-ec2-instance.id
}

output "private_ip" {
  description = "List of public DNS names assigned to the instances"
  value       = module.private-ec2-instance.private_ip
}

*/
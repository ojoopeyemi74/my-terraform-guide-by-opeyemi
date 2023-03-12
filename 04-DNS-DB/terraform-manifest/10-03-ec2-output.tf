# Ec2 Public output
output "ec2-public-id" {
  description = "List of IDs of instances"
  value       = module.bastion-ec2-instance.id
}

output "ec2-public-ip" {
  description = "List of public DNS names assigned to the instances"
  value       = module.bastion-ec2-instance.public_ip
}

# Ec2 Private output App1

output "ec2-private-ip-app1" {
  value = [for instance in module.private-ec2-instance-app1 : instance.private_ip]
}

output "ec2-private-id-app1" {
  value = [for instance in module.private-ec2-instance-app1 : instance.id]
}

# Ec2 Private output App2

output "ec2-private-ip-app2" {
  value = [for instance in module.private-ec2-instance-app2 : instance.private_ip]
}

output "ec2-private-id-app2" {
  value = [for instance in module.private-ec2-instance-app2 : instance.id]
}

# Ec2 Private output App3

output "ec2-private-ip-app3" {
  value = [for instance in module.private-ec2-instance-app3 : instance.private_ip]
}

output "ec2-private-id-app3" {
  value = [for instance in module.private-ec2-instance-app3 : instance.id]
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
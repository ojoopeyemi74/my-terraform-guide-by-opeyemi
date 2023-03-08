```
# EC2 latest version module

module "private-ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
depends_on = [module.vpc ]

  for_each = toset(["0", "1" ])

  name = "private-instance-${each.key}"

  ami               = data.aws_ami.amzlinux2.id
  instance_type     = var.instance_type
  key_name          = var.key_pair_name
  #monitoring             = true
  vpc_security_group_ids = [module.private-SG.security_group_id]
  subnet_id              = element(module.vpc.private_subnets, tonumber(each.key))

  user_data = file("${path.module}/00-app1-install.sh")

  tags = local.common_tags
  

}

```

```
## EC2 Output

output "ec2-private-ip-1" {
  value = [for instance in module.private-ec2-instance: instance.private_ip]
}

output "ec2-private-id-1" {
  value = [for instance in module.private-ec2-instance: instance.id]
}

```
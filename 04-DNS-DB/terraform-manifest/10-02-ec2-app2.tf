module "private-ec2-instance-app2" {
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "4.3.0"
  depends_on = [module.vpc]

  for_each = toset(["0", "1"])

  name = "app2-private-instance-${each.key}"

  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  #monitoring             = true
  vpc_security_group_ids = [module.private-SG.security_group_id]
  subnet_id              = element(module.vpc.private_subnets, tonumber(each.key))

  user_data = file("${path.module}/0-app2-install.sh")

  tags = local.common_tags


}
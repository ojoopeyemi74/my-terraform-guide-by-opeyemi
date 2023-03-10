# EC2 latest version module

module "private-ec2-instance-app1" {
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "4.3.0"
  depends_on = [module.vpc]

  for_each = toset(["0", "1"])

  name = "app1-private-instance-${each.key}"

  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  #monitoring             = true
  vpc_security_group_ids = [module.private-SG.security_group_id]
  subnet_id              = element(module.vpc.private_subnets, tonumber(each.key))

  user_data = file("${path.module}/0-app1-install.sh")

  tags = local.common_tags


}




/*
# EC2 old version module


module "ec2-private-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert the 10 required variables here
  depends_on = [module.vpc]
  name                   = "${var.environment}-private-instance"
  #instance_count         = 5

  ami                    = data.aws_ami.amzlinux2.id
  user_data              = file("${path.module}/00-app1-install.sh")
  instance_type          = var.instance_type
  instance_count         = var.private_instance_count
  key_name               = var.key_pair_name
  #monitoring             = true
  vpc_security_group_ids = [module.private-SG.security_group_id]
  subnet_ids             =  [
   module.vpc.private_subnets[0], module.vpc.private_subnets[1]
  ]

  tags = local.common_tags
}

*/

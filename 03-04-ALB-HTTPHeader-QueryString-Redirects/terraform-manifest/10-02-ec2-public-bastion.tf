# EC2 latest version module

module "bastion-ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name = "${local.name}-bastion-host"

  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  #monitoring             = true
  vpc_security_group_ids = [module.public-bastion-SG.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = local.common_tags
}


# EC2 old version module
/*
module "ec2-public-bastion-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert the 10 required variables here

  name                   = "${var.environment}-public-bastion-instance"
  #instance_count         = 5

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  #monitoring             = true
  vpc_security_group_ids = [module.public-bastion-SG.security_group_id]
  subnet_id             =  module.vpc.public_subnets[0]

  tags = local.common_tags
}

*/
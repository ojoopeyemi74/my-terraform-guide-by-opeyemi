module "public-bastion-SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name        = "public-sg-bastion"
  description = " SSH ports open for everyone"
  vpc_id      = module.vpc.vpc_id

  # Ingress Rules and CIDR blocks
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  # Egress rules all - all
  egress_rules = ["all-all"]

  tags = local.common_tags


}

module "private-SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name        = "private-sg"
  description = " SG with http and SSH port for entire VPC Cidr block"
  vpc_id      = module.vpc.vpc_id

  # Ingress Rules and CIDR blocks
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]

  # Egress rules all - all
  egress_rules = ["all-all"]

  tags = local.common_tags


}

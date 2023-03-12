module "rds-SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name        = "rds-sg"
  description = " SG with http and SSH port for entire VPC Cidr block"
  vpc_id      = module.vpc.vpc_id

  # Ingress 
 ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
 ]

  # Egress rules all - all
  egress_rules = ["all-all"]

  tags = local.common_tags


}

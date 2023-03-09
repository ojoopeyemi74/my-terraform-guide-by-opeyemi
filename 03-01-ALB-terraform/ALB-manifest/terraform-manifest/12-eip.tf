# create EIP to depend on Public EC2 and also VPC(IGW )before creation 

resource "aws_eip" "eip-bastion-public-instance" {
    depends_on = [
      module.bastion-ec2-instance, module.vpc
    ]
  instance = module.bastion-ec2-instance.id
  vpc      = true
  tags = local.common_tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.4.0"

name = "${local.name}-my-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups    = [module.loadbalancer-SG.security_group_id]

# Tagrget Groups

  target_groups = [
    {
      name_prefix      = "app1-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        vm-1 = {
          target_id = element([for instance in module.private-ec2-instance: instance.id], 0)
          port = 80
        } 
        vm-2 = {
          target_id = element([for instance in module.private-ec2-instance: instance.id], 1)
          port = 80
        } 
      
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = local.common_tags

}

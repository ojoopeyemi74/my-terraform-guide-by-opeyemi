
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.4.0"

  name = "${local.name}-my-alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups = [module.loadbalancer-SG.security_group_id]

  # Listeners
  # HTTP Listener - HTTP to HTTPS Redirect
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  # Tagrget Groups

  target_groups = [
    {
      # App1 Target group for index 0
      name_prefix          = "app1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        app1-vm = {
          target_id = element([for instance in module.private-ec2-instance-app1 : instance.id], 0)
          port      = 80
        },
        app2-vm = {
          target_id = element([for instance in module.private-ec2-instance-app1 : instance.id], 1)
          port      = 80
        }
      }
      tags = local.common_tags
    },
    # App2 Target group for index 1
    { name_prefix          = "app2"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        app1-vm = {
          target_id = element([for instance in module.private-ec2-instance-app2 : instance.id], 0)
          port      = 80
        },
        app2-vm = {
          target_id = element([for instance in module.private-ec2-instance-app2 : instance.id], 1)
          port      = 80
        }
      }
      tags = local.common_tags # Taget group tag
    }

  ]
  # HTTPS Listener
  https_listeners = [
    # HTTPS Listener Index = 0 for HTTPS 443
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.this_acm_certificate_arn
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }
    }, 
  ]
 
  # HTTPS Listener Rules
  https_listener_rules = [
    # Rule-1: custom-header=my-app-1 should go to App1 EC2 Instances
    { 
      https_listener_index = 0
      priority = 1      
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{ 
        #path_patterns = ["/app1*"]
        #host_headers = [var.app1_dns_name]
        http_headers = [{
          http_header_name = "custom-header"
          values           = ["app-1", "app1", "my-app-1"]
        }]
      }]
    },
    # Rule-2: custom-header=my-app-2 should go to App2 EC2 Instances    
    {
      https_listener_index = 0
      priority = 2      
      actions = [
        {
          type               = "forward"
          target_group_index = 1
        }
      ]
      conditions = [{
        #path_patterns = ["/app2*"] 
        #host_headers = [var.app2_dns_name]
        http_headers = [{
          http_header_name = "custom-header"
          values           = ["app-2", "app2", "my-app-2"]
        }]        
      }]
    },    
  # Rule-3: When Query-String, website=aws-eks redirect to https://stacksimplify.com/aws-eks/
    { 
      https_listener_index = 0
      priority = 3
      actions = [{
        type        = "redirect"
        status_code = "HTTP_302"
        host        = "stacksimplify.com"
        path        = "/aws-eks/"
        query       = ""
        protocol    = "HTTPS"
      }]
      conditions = [{
        query_strings = [{
          key   = "website"
          value = "aws-eks"
          }]
      }]
    },
  # Rule-4: When Host Header = azure-aks.devopsincloud.com, redirect to https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
    { 
      https_listener_index = 0
      priority = 4
      actions = [{
        type        = "redirect"
        status_code = "HTTP_302"
        host        = "stacksimplify.com"
        path        = "/azure-aks/azure-kubernetes-service-introduction/"
        query       = ""
        protocol    = "HTTPS"
      }]
      conditions = [{
        host_headers = ["azure-aks101.neuniktechnologygroup.com.com"]
      }]
    },    
  ]
  tags = local.common_tags # ALB Tags
}



## Step-01: c10-02-ALB-application-loadbalancer.tf
- Define different HTTPS Listener Rules for ALB Load Balancer
### Step-02-01: Rule-1: Custom Header Rule for App-1
- Rule-1: custom-header=my-app-1 should go to App1 EC2 Instances
```t
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
```
### Step-02-02: Rule-2: Custom Header Rule for App-1
- Rule-2: custom-header=my-app-2 should go to App2 EC2 Instances    
```t
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
```
### Step-02-03: Rule-3: Query String Redirect
- Rule-3: When Query-String, website=aws-eks redirect to https://stacksimplify.com/aws-eks/
```t
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
```
### Step-02-04: Rule-4: Host Header Redirect
- Rule-4: When Host Header = azure-aks.neuniktechnologygroup.com, redirect to https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
```t
  # Rule-4: When Host Header = azure-aks.neuniktechnologygroup.com, redirect to https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
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
        host_headers = ["azure-aks11.neuniktechnologygroup.com"]
      }]
    },   
```

## Step-03: c12-route53-dnsregistration.tf
```t
# DNS Registration 
## Default DNS
resource "aws_route53_record" "default_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = "myapps11.neuniktechnologygroup.com"
  type    = "A"
  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }  
}

## Testing Host Header - Redirect to External Site from ALB HTTPS Listener Rules
resource "aws_route53_record" "app1_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = "azure-aks11.neuniktechnologygroup.com"
  type    = "A"
  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }  
}
```


## Step-05: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terrform Apply
terraform apply -auto-approve
```

## Step-06: Verify HTTP Header Based Routing (Rule-1 and Rule-2)
- Rest Clinets we can use
- https://restninja.io/ 
- https://www.webtools.services/online-rest-api-client
- https://reqbin.com/
```t
# Verify Rule-1 and Rule-2
https://myapps.neuniktechnologygroup.com
custom-header = my-app-1  - Should get the page from App1 
custom-header = my-app-2  - Should get the page from App2
```

## Step-07: Verify Rule-3 
- When Query-String, website=aws-eks redirect to https://stacksimplify.com/aws-eks/
```t
# Verify Rule-3
https://myapps.neuniktechnologygroup.com/?website=aws-eks 
Observation: 
1. Should Redirect to https://stacksimplify.com/aws-eks/
```

## Step-08: Verify Rule-4
-  When Host Header = azure-aks.neuniktechnologygroup.com, redirect to https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
```t
# Verify Rule-4
http://azure-aks.neuniktechnologygroup.com
Observation: 
1. Should redirect to https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
```

## Step-09: Clean-Up
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate
```


## References
- [Terraform AWS ALB](https://github.com/terraform-aws-modules/terraform-aws-alb)

## Step-01: ALB-application-loadbalancer-variables.tf
- We will be using these variables in two places
  - c10-02-ALB-application-loadbalancer.tf
  - c12-route53-dnsregistration.tf
- If we are using the values in more than one place its good to variablize that value  
```t
# App1 DNS Name
variable "app1_dns_name" {
  description = "App1 DNS Name"
}

# App2 DNS Name
variable "app2_dns_name" {
  description = "App2 DNS Name"
}
```
## Step-06: loadbalancer.auto.tfvars
```t
# AWS Load Balancer Variables
app1_dns_name = "app16.neuniktechnologygroup.com"
app2_dns_name = "app26.neuniktechnologygroup.com"
```

## Step-06: c10-02-ALB-application-loadbalancer.tf
### Step-06-01: HTTPS Listener Rule-1
```t
      conditions = [{
        #path_patterns = ["/app1*"]
        host_headers = [var.app1_dns_name]
      }]
```
### Step-06-02: HTTPS Listener Rule-2
```t
      conditions = [{
        #path_patterns = ["/app2*"] 
        host_headers = [var.app2_dns_name]
      }]
```

## Step-07: c12-route53-dnsregistration.tf
### Step-07-01: App1 DNS
```t
## Default DNS
resource "aws_route53_record" "default_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = "myapps.neuniktechnologygroup.com"
  type    = "A"
  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }  
}

# DNS Registration 
## App1 DNS
resource "aws_route53_record" "app1_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = var.app1_dns_name
  type    = "A"
  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }  
}
```
### Step-07-02: App2 DNS
```t
## App2 DNS
resource "aws_route53_record" "app2_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = var.app2_dns_name
  type    = "A"
  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }  
}
```

## Step-08: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Verify
Observation: 
1. Verify EC2 Instances for App1
2. Verify EC2 Instances for App2
3. Verify Load Balancer SG - Primarily SSL 443 Rule
4. Verify ALB Listener - HTTP:80 - Should contain a redirect from HTTP to HTTPS
5. Verify ALB Listener - HTTPS:443 - Should contain 3 rules 
5.1 Host Header app1.neuniktechnologygroup.com to app1-tg 
5.2 Host Header app2.neuniktechnologygroup.com toto app2-tg 
5.3 Fixed Response: any other errors or any other IP or valid DNS to this LB
6. Verify ALB Target Groups App1 and App2, Targets (should be healthy) 
5. Verify SSL Certificate (Certificate Manager)
6. Verify Route53 DNS Record

# Test (Domain will be different for you based on your registered domain)
# Note: All the below URLS shoud redirect from HTTP to HTTPS
# App1
1. App1 Landing Page index.html at Root Context of App1: http://app1.neuniktechnologygroup.com
2. App1 /app1/index.html: http://app1.neuniktechnologygroup.com/app1/index.html
3. App1 /app1/metadata.html: http://app1.neuniktechnologygroup.com/app1/metadata.html
4. Failure Case: Access App2 Directory from App1 DNS: http://app1.neuniktechnologygroup.com/app2/index.html - Should return Directory not found 404

# App2
1. App2 Landing Page index.html at Root Context of App1: http://app2.neuniktechnologygroup.com
2. App1 /app2/index.html: http://app1.neuniktechnologygroup.com/app2/index.html
3. App1 /app2/metadata.html: http://app1.neuniktechnologygroup.com/app2/metadata.html
4. Failure Case: Access App2 Directory from App1 DNS: http://app2.neuniktechnologygroup.com/app1/index.html - Should return Directory not found 404
```


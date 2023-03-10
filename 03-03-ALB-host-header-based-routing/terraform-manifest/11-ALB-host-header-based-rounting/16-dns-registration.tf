resource "aws_route53_record" "default-dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "apps.neuniktechnologygroup.com"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app1-dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.app1-dns-name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "app2-dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = var.app2-dns-name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}
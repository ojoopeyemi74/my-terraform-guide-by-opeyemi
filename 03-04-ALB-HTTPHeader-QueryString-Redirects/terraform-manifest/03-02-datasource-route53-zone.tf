# Get DNS information from AWS Route53
data "aws_route53_zone" "mydomain" {
  name = "neuniktechnologygroup.com"
}




#  Hosted Zone id of the desired Hosted Zone
output "hosted-zone-id" {
  description = "Hosted Zone id of the desired Hosted Zone."
  value       = data.aws_route53_zone.mydomain.zone_id
}

# Hosted Zone name of the desired Hosted Zone
output "hosted-zone-name" {
  description = "Hosted Zone name of the desired Hosted Zone"
  value       = data.aws_route53_zone.mydomain.name
}
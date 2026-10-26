output "acm_certificate_arn" {
  description = "ARN of the wildcard ACM certificate"
  value       = aws_acm_certificate.wildcard.arn
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = local.zone_id
}

output "route53_zone_arn" {
  description = "Route53 hosted zone ARN"
  value       = data.aws_route53_zone.main.arn
}

output "domain_name" {
  description = "Domain name"
  value       = local.domain_name
}

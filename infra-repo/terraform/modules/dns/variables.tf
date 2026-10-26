variable "domain_name" {
  description = "Domain name for the hosted zone (e.g., example.com)"
  type        = string
}

variable "route53_zone_id" {
  description = "Existing Route53 hosted zone ID"
  type        = string
}

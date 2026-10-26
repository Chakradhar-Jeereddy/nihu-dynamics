output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "thanos_bucket_name" {
  description = "Thanos S3 bucket name"
  value       = module.s3.thanos_bucket_name
}

output "harbor_bucket_name" {
  description = "Harbor S3 bucket name"
  value       = module.s3.harbor_bucket_name
}

output "acm_certificate_arn" {
  description = "Wildcard ACM certificate ARN"
  value       = module.dns.acm_certificate_arn
}

output "thanos_role_arn" {
  description = "Thanos IRSA role ARN"
  value       = module.iam.thanos_role_arn
}

output "harbor_role_arn" {
  description = "Harbor IRSA role ARN"
  value       = module.iam.harbor_role_arn
}

output "external_dns_role_arn" {
  description = "External DNS IRSA role ARN"
  value       = module.iam.external_dns_role_arn
}

output "cert_manager_role_arn" {
  description = "cert-manager IRSA role ARN"
  value       = module.iam.cert_manager_role_arn
}

output "aws_lb_controller_role_arn" {
  description = "AWS LB Controller IRSA role ARN"
  value       = module.iam.aws_lb_controller_role_arn
}

output "domain_name" {
  description = "Domain name"
  value       = module.dns.domain_name
}

output "route53_zone_id" {
  description = "Route53 zone ID"
  value       = module.dns.route53_zone_id
}

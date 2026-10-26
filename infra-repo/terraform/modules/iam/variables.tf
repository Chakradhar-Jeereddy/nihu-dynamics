variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN from EKS"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL (without https://)"
  type        = string
}

variable "thanos_bucket_arn" {
  description = "ARN of the Thanos S3 bucket"
  type        = string
}

variable "harbor_bucket_arn" {
  description = "ARN of the Harbor S3 bucket"
  type        = string
}

variable "route53_zone_arn" {
  description = "ARN of the Route53 hosted zone"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

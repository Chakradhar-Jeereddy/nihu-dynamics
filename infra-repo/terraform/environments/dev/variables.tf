variable "region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
}

variable "domain_name" {
  description = "Domain name (e.g., example.com)"
  type        = string
}

variable "route53_zone_id" {
  description = "Existing Route53 hosted zone ID"
  type        = string
}

variable "api_allowed_cidrs" {
  description = "CIDR blocks allowed to access the EKS API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "thanos_retention_days" {
  description = "Days before transitioning Thanos data to Infrequent Access"
  type        = number
  default     = 90
}

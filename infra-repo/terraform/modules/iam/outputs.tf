output "thanos_role_arn" {
  description = "IAM role ARN for Thanos"
  value       = aws_iam_role.thanos.arn
}

output "harbor_role_arn" {
  description = "IAM role ARN for Harbor"
  value       = aws_iam_role.harbor.arn
}

output "external_dns_role_arn" {
  description = "IAM role ARN for External DNS"
  value       = aws_iam_role.external_dns.arn
}

output "cert_manager_role_arn" {
  description = "IAM role ARN for cert-manager"
  value       = aws_iam_role.cert_manager.arn
}

output "aws_lb_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = aws_iam_role.aws_lb_controller.arn
}

output "thanos_bucket_name" {
  description = "Name of the Thanos metrics S3 bucket"
  value       = aws_s3_bucket.thanos.id
}

output "thanos_bucket_arn" {
  description = "ARN of the Thanos metrics S3 bucket"
  value       = aws_s3_bucket.thanos.arn
}

output "harbor_bucket_name" {
  description = "Name of the Harbor storage S3 bucket"
  value       = aws_s3_bucket.harbor.id
}

output "harbor_bucket_arn" {
  description = "ARN of the Harbor storage S3 bucket"
  value       = aws_s3_bucket.harbor.arn
}

output "thanos_bucket_region" {
  description = "Region of the Thanos S3 bucket"
  value       = aws_s3_bucket.thanos.region
}

output "harbor_bucket_region" {
  description = "Region of the Harbor S3 bucket"
  value       = aws_s3_bucket.harbor.region
}

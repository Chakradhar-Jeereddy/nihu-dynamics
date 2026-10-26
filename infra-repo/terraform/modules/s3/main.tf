# --- Thanos Metrics Bucket ---

resource "aws_s3_bucket" "thanos" {
  bucket = local.thanos_bucket_name

  tags = {
    Name    = local.thanos_bucket_name
    Purpose = "thanos-long-term-metrics"
  }
}

resource "aws_s3_bucket_versioning" "thanos" {
  bucket = aws_s3_bucket.thanos.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "thanos" {
  bucket = aws_s3_bucket.thanos.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "thanos" {
  bucket = aws_s3_bucket.thanos.id

  rule {
    id     = "transition-to-ia"
    status = "Enabled"

    transition {
      days          = var.thanos_retention_days
      storage_class = "STANDARD_IA"
    }
  }
}

# --- Harbor Storage Bucket ---

resource "aws_s3_bucket" "harbor" {
  bucket = local.harbor_bucket_name

  tags = {
    Name    = local.harbor_bucket_name
    Purpose = "harbor-registry-storage"
  }
}

resource "aws_s3_bucket_versioning" "harbor" {
  bucket = aws_s3_bucket.harbor.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "harbor" {
  bucket = aws_s3_bucket.harbor.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

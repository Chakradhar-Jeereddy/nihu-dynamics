locals {
  name_prefix = "${var.project_name}-${var.environment}"
  account_id  = data.aws_caller_identity.current.account_id

  thanos_bucket_name = "${local.name_prefix}-thanos-metrics-${local.account_id}"
  harbor_bucket_name = "${local.name_prefix}-harbor-storage-${local.account_id}"
}

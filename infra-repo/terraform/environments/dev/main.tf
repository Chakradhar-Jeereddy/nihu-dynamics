module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  region             = var.region
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  cluster_name       = local.cluster_name
  enable_flow_logs   = true
}

module "eks" {
  source = "../../modules/eks"

  project_name               = var.project_name
  environment                = var.environment
  cluster_name               = local.cluster_name
  cluster_version            = var.cluster_version
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  public_subnet_ids          = module.vpc.public_subnet_ids
  api_allowed_cidrs          = var.api_allowed_cidrs
  system_node_instance_types = ["t3.xlarge"]
  system_node_desired        = 2
  system_node_min            = 2
  system_node_max            = 3
}

module "s3" {
  source = "../../modules/s3"

  project_name          = var.project_name
  environment           = var.environment
  thanos_retention_days = 90
}

module "dns" {
  source = "../../modules/dns"

  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id
}

module "iam" {
  source = "../../modules/iam"

  project_name      = var.project_name
  environment       = var.environment
  cluster_name      = local.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  thanos_bucket_arn = module.s3.thanos_bucket_arn
  harbor_bucket_arn = module.s3.harbor_bucket_arn
  route53_zone_arn  = module.dns.route53_zone_arn
}

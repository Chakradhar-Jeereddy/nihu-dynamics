# Nihu Dynamics — Infrastructure Repository

Terraform infrastructure for the Nihu Dynamics EKS platform on AWS.

## Architecture

- **VPC**: 3-AZ public/private subnets with NAT Gateway and VPC Flow Logs
- **EKS**: Kubernetes 1.31 cluster with managed node groups
- **S3**: Buckets for Thanos metrics storage and Harbor registry storage
- **IAM**: IRSA roles for Thanos, Harbor, External DNS, cert-manager, AWS LB Controller
- **DNS**: ACM wildcard certificate with Route53 DNS validation

## Directory Structure

```
terraform/
├── backend/              # S3 state bucket bootstrap
├── modules/
│   ├── vpc/              # VPC, subnets, NAT, flow logs
│   ├── eks/              # EKS cluster, node groups, addons
│   ├── iam/              # IRSA roles for K8s service accounts
│   ├── s3/               # Thanos + Harbor S3 buckets
│   └── dns/              # ACM certificate + Route53
└── environments/
    └── dev/              # Dev environment root module
```

## Prerequisites

- Terraform >= 1.10.0
- AWS CLI configured with appropriate credentials
- Existing Route53 hosted zone

## Getting Started

### 1. Bootstrap Terraform State

```bash
cd terraform/backend
terraform init
terraform apply
```

Note the S3 bucket name from the output and update `terraform/environments/dev/versions.tf` with the actual bucket name.

### 2. Configure Variables

Edit `terraform/environments/dev/terraform.tfvars` with your actual values:
- `domain_name`: Your domain (e.g., `nihu-dynamics.com`)
- `route53_zone_id`: Your existing Route53 hosted zone ID
- `api_allowed_cidrs`: CIDR blocks to restrict EKS API access

### 3. Deploy Infrastructure

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### 4. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name nihu-dynamics-dev
```

## CI/CD

- **PR**: Triggers `terraform plan` and posts output as PR comment
- **Merge to main**: Triggers `terraform apply` with environment protection

Required GitHub Secrets:
- `AWS_ROLE_ARN`: IAM role ARN for GitHub Actions OIDC authentication

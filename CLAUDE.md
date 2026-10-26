# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Nihu Dynamics EKS platform — a two-repo monorepo (both repos in one git root) for deploying a production Kubernetes platform on AWS (us-east-1). **infra-repo** provisions AWS infrastructure with Terraform; **app-repo** deploys platform components via ArgoCD GitOps.

## Commands

### Terraform (infra-repo)

```bash
# Bootstrap state bucket (one-time)
cd infra-repo/terraform/backend && terraform init && terraform apply

# Plan/apply dev environment
cd infra-repo/terraform/environments/dev
terraform init
terraform plan
terraform apply

# Format check (CI runs this)
terraform fmt -check -recursive

# Validate
terraform validate
```

### App manifests (app-repo)

```bash
# Lint YAML
yamllint -d "{extends: default, rules: {line-length: {max: 200}, truthy: disable}}" argocd/ helm-values/

# Validate Kubernetes manifests
find argocd/ -name '*.yaml' | xargs kubeconform -strict -ignore-missing-schemas -summary

# Helm template validation (example)
helm template test prometheus-community/kube-prometheus-stack -f helm-values/kube-prometheus-stack/values.yaml --dry-run > /dev/null
```

### Cluster access

```bash
aws eks update-kubeconfig --region us-east-1 --name nihu-dynamics-dev
```

## Architecture

### Two-repo split

- **infra-repo/terraform/** — AWS resources: VPC, EKS, S3, IAM (IRSA), DNS/ACM. Terraform >= 1.10, AWS provider ~> 5.70.
- **app-repo/** — Kubernetes platform manifests: ArgoCD Applications, Helm values, Grafana dashboard JSON, CI workflows.

The infra-repo outputs (role ARNs, bucket names, cert ARN, VPC ID) feed into app-repo Helm values as `REPLACE_WITH_*` placeholders.

### Terraform module structure

Each module under `infra-repo/terraform/modules/` uses separated files: `main.tf`, `variables.tf`, `outputs.tf`, `locals.tf`, `data.tf`. The dev environment root at `environments/dev/` composes all modules and wires outputs between them (e.g., EKS OIDC provider → IAM module for IRSA roles).

State backend: S3 with native locking (`use_lockfile = true`), no DynamoDB, no encryption block.

### IAM / IRSA pattern

The IAM module creates one IRSA role per platform component (thanos, harbor, external-dns, cert-manager, aws-lb-controller). Namespace and service account mappings are defined in `infra-repo/terraform/modules/iam/locals.tf` as the `irsa_roles` map. Adding a new IRSA role means: add an entry to that map, create the role + policy resources in `iam/main.tf`, and expose the ARN via `outputs.tf`.

### ArgoCD app-of-apps with sync waves

The app-of-apps root (`argocd/applications/app-of-apps.yaml`) auto-syncs all Application manifests. Deployment order is enforced via sync-wave annotations:

1. cert-manager
2. aws-lb-controller, external-dns
3. kube-prometheus-stack (monitoring)
4. opentelemetry, thanos
5. grafana-dashboards, harbor

New applications must be assigned a sync-wave that respects dependency order. Applications use multi-source (Helm chart + Git values ref) where values live in `helm-values/`.

### CI/CD

**infra-repo**: PR → `terraform fmt -check` + `terraform plan` (posted as PR comment). Merge to main → `terraform apply`. Auth via GitHub Actions OIDC (`AWS_ROLE_ARN` secret).

**app-repo**: PR → yamllint + Helm template validation + kubeconform. Push to main → Docker build + push to Harbor.

## Conventions

- Naming: `${project_name}-${environment}` prefix throughout (e.g., `nihu-dynamics-dev`)
- Terraform: all resources use `default_tags` from the provider block (Project, Environment, ManagedBy). Additional Name tags on individual resources.
- ArgoCD Applications: always include `resources-finalizer.argocd.argoproj.io` finalizer, automated sync with prune + selfHeal, `CreateNamespace=true` sync option
- EKS addons (coredns, kube-proxy, vpc-cni, ebs-csi) are managed by Terraform, not ArgoCD

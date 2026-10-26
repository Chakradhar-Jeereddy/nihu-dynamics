# Nihu Dynamics — Application Repository

Kubernetes platform manifests, Helm values, and CI/CD pipelines for the Nihu Dynamics EKS platform.

## Architecture

This repo is the GitOps source of truth for all platform components deployed via ArgoCD:

- **ArgoCD** — GitOps deployment engine (app-of-apps pattern)
- **cert-manager** — TLS certificate management via Let's Encrypt + Route53
- **external-dns** — Automatic DNS record management
- **AWS Load Balancer Controller** — ALB/NLB ingress support
- **kube-prometheus-stack** — Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics
- **Thanos** — Long-term metrics storage (S3-backed) with global querying
- **OpenTelemetry Collector** — Metrics, traces, and logs collection (DaemonSet)
- **Harbor** — Container image registry with Trivy vulnerability scanning
- **Grafana Dashboards** — Pre-built dashboards for cluster, node, pod, namespace, network, latency, errors, and Harbor metrics

## Directory Structure

```
├── argocd/
│   ├── install/                    # ArgoCD Helm values
│   └── applications/               # App-of-apps + individual ArgoCD Applications
├── helm-values/
│   ├── cert-manager/               # cert-manager values + ClusterIssuer
│   ├── external-dns/               # external-dns values
│   ├── aws-lb-controller/          # AWS LB controller values
│   ├── kube-prometheus-stack/       # Prometheus + Grafana + Alertmanager values
│   ├── thanos/                     # Thanos values + objstore secret
│   ├── opentelemetry-collector/     # OTel Collector DaemonSet values
│   ├── harbor/                     # Harbor registry values
│   └── grafana-dashboards/         # Dashboard JSON files + ConfigMaps
└── .github/workflows/
    ├── build-push.yml              # Build image → push to Harbor
    └── lint-manifests.yml          # YAML lint + Helm validation + kubeconform
```

## Monitoring Coverage

| Area | What's Monitored |
|------|-----------------|
| **Cluster** | Node count, pod count, CPU/memory utilization, health status |
| **Nodes** | CPU, memory, disk, network I/O, filesystem, conditions |
| **Pods** | CPU/memory per pod, restarts, OOMKills, container states |
| **Namespaces** | Resource quotas, limits, pod counts, usage per namespace |
| **Network** | Traffic I/O, packet drops, network errors, DNS latency, conntrack |
| **Latency & Errors** | API server latency p50/p95/p99, 4xx/5xx rates, error budgets |
| **Harbor** | Health, push/pull rates, storage usage, Trivy scan results |

## Getting Started

### Prerequisites

- EKS cluster deployed via the infra-repo
- `kubectl` configured for the cluster
- `helm` v3.16+

### 1. Install ArgoCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd \
  --namespace argocd --create-namespace \
  -f argocd/install/values.yaml
```

### 2. Create Required Secrets

```bash
# Thanos object store config
kubectl apply -f helm-values/thanos/objstore-secret.yaml

# cert-manager ClusterIssuer (after cert-manager is running)
kubectl apply -f helm-values/cert-manager/cluster-issuer.yaml
```

### 3. Deploy App of Apps

```bash
kubectl apply -f argocd/applications/app-of-apps.yaml
```

ArgoCD will sync all platform components in the correct order (using sync waves).

### 4. Access Services

After DNS propagation:
- **ArgoCD**: `https://argocd.example.com`
- **Grafana**: `https://grafana.example.com`
- **Thanos**: `https://thanos.example.com`
- **Harbor**: `https://harbor.example.com`

## Configuration

Replace all `REPLACE_WITH_*` placeholders in the Helm values files with actual values from the Terraform outputs:

| Placeholder | Source |
|------------|--------|
| `REPLACE_WITH_ACM_CERT_ARN` | `terraform output acm_certificate_arn` |
| `REPLACE_WITH_VPC_ID` | `terraform output vpc_id` |
| `REPLACE_WITH_*_ROLE_ARN` | `terraform output <component>_role_arn` |
| `REPLACE_WITH_THANOS_BUCKET_NAME` | `terraform output thanos_bucket_name` |
| `REPLACE_WITH_HARBOR_BUCKET_NAME` | `terraform output harbor_bucket_name` |
| `example.com` | Your actual domain name |
| `REPLACE_ORG` | Your GitHub organization |

## CI/CD

- **PR**: Triggers YAML lint, Helm validation, and kubeconform checks
- **Push to main**: Builds Docker image, pushes to Harbor, updates image tag

Required GitHub Secrets:
- `HARBOR_USERNAME`: Harbor robot account username
- `HARBOR_PASSWORD`: Harbor robot account password

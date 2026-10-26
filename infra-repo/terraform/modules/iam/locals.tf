locals {
  oidc_provider_url = var.oidc_provider_url
  oidc_provider_arn = var.oidc_provider_arn
  name_prefix       = "${var.project_name}-${var.environment}"

  irsa_roles = {
    thanos = {
      namespace       = "monitoring"
      service_account = "thanos"
    }
    harbor = {
      namespace       = "harbor"
      service_account = "harbor-registry"
    }
    external_dns = {
      namespace       = "external-dns"
      service_account = "external-dns"
    }
    cert_manager = {
      namespace       = "cert-manager"
      service_account = "cert-manager"
    }
    aws_lb_controller = {
      namespace       = "kube-system"
      service_account = "aws-load-balancer-controller"
    }
  }
}

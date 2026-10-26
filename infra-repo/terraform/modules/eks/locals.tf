locals {
  cluster_name = var.cluster_name
  subnet_ids   = concat(var.public_subnet_ids, var.private_subnet_ids)

  eks_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent            = true
      service_account_role_arn = aws_iam_role.ebs_csi.arn
    }
  }

  system_node_labels = {
    role = "system"
  }

  system_node_taints = []

  common_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

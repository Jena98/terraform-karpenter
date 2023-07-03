locals {
  # set eks variables from backend s3
  eks_cluster_name                       = var.eks_cluster_name == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_name : var.eks_cluster_name
  eks_endpoint_url                       = var.eks_endpoint_url == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_endpoint : var.eks_endpoint_url
  eks_cluster_certificate_authority_data = var.eks_cluster_certificate_authority_data == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data : var.eks_cluster_certificate_authority_data
  eks_auth_token                         = data.aws_eks_cluster_auth.cluster.token

  eks_oidc_provider_arn = var.eks_oidc_provider_arn == "" ? data.terraform_remote_state.eks.outputs.eks_oidc_provider_arn : var.eks_oidc_provider_arn
  eks_oidc_provider_url = var.eks_oidc_provider_url == "" ? data.terraform_remote_state.eks.outputs.eks_oidc_provider_url : var.eks_oidc_provider_url

  node_role_name              = format("%s-KarpenterNodeRole-%s", local.eks_cluster_name, random_string.random.result)
  node_instance_profile       = format("%s-KarpenterNodeInstanceProfile-%s", local.eks_cluster_name, random_string.random.result)
  service_account_role_name   = format("%s-karpenter-controller-%s", local.eks_cluster_name, random_string.random.result)
  service_account_policy_name = format("%s-karpenter-controller-policy-%s", local.eks_cluster_name, random_string.random.result)

  node_role_arn = aws_iam_role.node.arn

  common_tags = merge(var.default_tags, {
    "project" = var.project
    "region"  = var.region
    "env"     = var.env
    "managed" = "terraform"
  })

  karpenter_values = merge(
    { nodeSelector = var.node_selector },
    { affinity = var.affinity },
    { tolerations = var.tolerations },
    { resources = var.resources }
  )
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}
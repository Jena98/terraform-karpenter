module "karpenter" {
  source = "./modules"

  eks_cluster_name = local.eks_cluster_name
  eks_endpoint_url = local.eks_endpoint_url

  eks_oidc_provider_arn = local.eks_oidc_provider_arn
  eks_oidc_provider_url = local.eks_oidc_provider_url

  helm_release_name   = var.helm_release_name
  helm_chart_name     = var.helm_chart_name
  helm_chart_version  = var.helm_chart_version
  helm_repository_url = var.helm_repository_url

  create_namespace = var.create_namespace
  namespace        = var.namespace

  node_instance_profile       = local.node_instance_profile
  service_account_role_name   = local.service_account_role_name
  service_account_policy_name = local.service_account_policy_name

  common_tags = local.common_tags

  karpenter_values = local.karpenter_values
}
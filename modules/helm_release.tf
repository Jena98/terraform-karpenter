resource "helm_release" "karpenter" {
  name       = var.helm_release_name
  chart      = var.helm_chart_name
  version    = var.helm_chart_version == "" ? null : var.helm_chart_version
  repository = var.helm_repository_url

  create_namespace = var.create_namespace
  namespace        = var.namespace

  values = [yamlencode((var.karpenter_values))]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter.arn
  }

  set {
    name  = "serviceAccount.name"
    value = aws_iam_role.karpenter.name
  }

  set {
    name  = "settings.aws.clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = var.eks_endpoint_url
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = var.node_instance_profile
  }

  set {
    name  = "replicas"
    value = var.replica_count
  }
}

############################################
# AWS Provider Configuration
############################################
provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(local.eks_cluster_certificate_authority_data)
    host                   = local.eks_endpoint_url
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(local.eks_cluster_certificate_authority_data)
  host                   = local.eks_endpoint_url
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = local.eks_endpoint_url
  cluster_ca_certificate = base64decode(local.eks_cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", local.eks_cluster_name]
  }
}
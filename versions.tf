############################################
# version of terraform and providers
############################################
terraform {
  required_version = ">= 1.2.0, < 2.0.0"

  required_providers {
    aws        = "~> 4.4.0"
    random     = "~> 3.1.0"
    kubernetes = "~> 2.11.0"
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

variable "project" {
  default = ""
}

variable "env" {
  default = ""
}

variable "region" {
  description = "aws region to build network infrastructure"
  default     = ""
}

variable "common_tags" {
  description = "common tags"
  default     = {}
}

variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "eks_endpoint_url" {
  type        = string
  default     = ""
  description = "eks endpoint url"
}

variable "eks_cluster_certificate_authority_data" {
  type        = string
  default     = ""
  description = "eks cluster ca certificate"
}

variable "eks_auth_token" {
  type        = string
  default     = ""
  description = "eks cluster auth token"
}

variable "eks_oidc_provider_arn" {
  type        = string
  default     = ""
  description = "openid connect provider arn"
}

variable "eks_oidc_provider_url" {
  type        = string
  default     = ""
  description = "openid connect provider url"
}

variable "helm_release_name" {
  type        = string
  default     = "karpenter"
  description = "helm release name"
}

variable "helm_chart_name" {
  type        = string
  default     = "karpenter"
  description = "helm chart name"
}

variable "helm_chart_version" {
  type        = string
  default     = ""
  description = "helm chart version"
}

variable "helm_repository_url" {
  type        = string
  default     = "oci://public.ecr.aws/karpenter"
  description = "helm chart repository url"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "create the namespace if it does not yet exist"
}

variable "namespace" {
  type    = string
  default = "karpenter"
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "default_tags" {
  default = {}
}

variable "karpenter_values" {
  default = {}
}

variable "resources" {
  type    = map(any)
  default = {}
}

variable "node_selector" {
  type    = map(any)
  default = {}
}

variable "affinity" {
  type    = map(any)
  default = {}
}

variable "tolerations" {
  type    = list(any)
  default = []
}

variable "crds" {
  default = {}
}
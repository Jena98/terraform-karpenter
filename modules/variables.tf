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
  description = "url of eks master."
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
  default     = ""
  description = "helm release name"
}

variable "helm_chart_name" {
  type        = string
  default     = ""
  description = "helm chart name"
}

variable "helm_chart_version" {
  type        = string
  default     = ""
  description = "helm chart version"
}

variable "helm_repository_url" {
  type        = string
  default     = ""
  description = "helm chart repository url"
}

variable "create_namespace" {
  type        = bool
  default     = true
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

variable "node_instance_profile" {
  type    = string
  default = ""
}

variable "service_account_role_name" {
  type    = string
  default = ""
}

variable "service_account_policy_name" {
  type    = string
  default = ""
}

variable "service_account_arn" {
  type    = string
  default = ""
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
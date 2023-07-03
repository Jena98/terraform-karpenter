resource "kubectl_manifest" "provisioner" {
  for_each = var.crds

  yaml_body = each.value

  depends_on = [
    module.karpenter
  ]
}
resource "helm_release" "valkey_operator" {
  name             = "valkey-operator"
  namespace        = var.namespace
  create_namespace = true
  chart            = "valkey-operator"
  repository       = "https://valkey.io/valkey-helm"
  version          = var.chart_version
}

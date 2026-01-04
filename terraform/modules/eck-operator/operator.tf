resource "helm_release" "elastic_operator" {
  name             = "eck-operator"
  namespace        = var.namespace
  create_namespace = true
  chart            = "eck-operator"
  repository       = "https://helm.elastic.co"
  version          = var.chart_version
}
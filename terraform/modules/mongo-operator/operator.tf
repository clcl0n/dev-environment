resource "helm_release" "mongodb_operator" {
  name             = "mongodb-community-operator"
  namespace        = var.namespace
  create_namespace = true
  chart            = "community-operator"
  repository       = "https://mongodb.github.io/helm-charts"
  version          = var.chart_version

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name = "operator.watchNamespace"
      value = "*"
    }
  ]
}

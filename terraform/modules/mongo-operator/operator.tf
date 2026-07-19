resource "helm_release" "mongodb_operator" {
  name             = "mongodb-operator"
  namespace        = var.namespace
  create_namespace = true
  chart            = "mongodb-kubernetes"
  repository       = "https://mongodb.github.io/helm-charts"
  version          = var.chart_version

  set = [
    {
      name  = "operator.watchNamespace"
      value = var.watch_namespace
    },
    {
      name  = "operator.createResourcesServiceAccountsAndRoles"
      value = "true"
    }
  ]
}

resource "helm_release" "postgres_operator" {
  name             = "cnpg"
  namespace        = var.namespace
  create_namespace = true
  chart            = "cloudnative-pg"
  repository       = "https://cloudnative-pg.github.io/charts"
  version          = var.chart_version

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}
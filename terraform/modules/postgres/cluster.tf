resource "kubernetes_namespace" "postgres_cluster_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "postgres_cluster" {
  name       = var.cluster_name
  namespace  = var.namespace
  chart      = "cluster"
  repository = "https://cloudnative-pg.github.io/charts"
  version    = "0.3.1"

  depends_on = [kubernetes_secret.postgres_superuser_secret, kubernetes_namespace.postgres_cluster_namespace]

  values = [
    <<EOT
version:
  postgresql: "${var.image.tag}"
cluster:
  instances: ${var.resources.replica_count}
  resources:
    requests:
      memory: ${var.resources.requests.memory}
      cpu: ${var.resources.requests.cpu}
    limits:
      memory: ${var.resources.limits.memory}
      cpu: ${var.resources.limits.cpu}
  postgresql:
    parameters:
      max_wal_size: "8GB"
      max_connections: "1000"
  storage:
    size: ${var.persistence.storage_size}
  superuserSecret: "${var.cluster_name}-cluster-superuser"
EOT
  ]

}

resource "kubernetes_secret" "postgres_superuser_secret" {
  depends_on = [kubernetes_namespace.postgres_cluster_namespace]

  metadata {
    name      = "${var.cluster_name}-cluster-superuser"
    namespace = var.namespace
  }

  data = {
    username = var.database_superuser_name
    password = var.database_superuser_password
  }

  type = "kubernetes.io/basic-auth"
}
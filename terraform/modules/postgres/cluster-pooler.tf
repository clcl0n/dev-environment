resource "kubernetes_manifest" "postgres_pooler" {
  depends_on = [helm_release.postgres_cluster]

  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Pooler"
    metadata = {
      name      = "${var.cluster_name}-pooler"
      namespace = var.namespace
    }
    spec = {
      cluster = {
        name = var.cluster_name
      }
      instances = 1
      type      = "rw"
      serviceTemplate = {
        metadata = {
          labels = {
            app = "pooler"
          }
        }
        spec = {
          type = "LoadBalancer"
        }
      }
      pgbouncer = {
        poolMode = "session"
        parameters = {
          max_client_conn   = "100"
          default_pool_size = "20"
        }
      }
    }
  }
}
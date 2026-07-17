# zvazit ci pouzivat bouncer lebo pri pg_restore je nepouzitelny skor mat bouncer na vsetko ostatne
# a na pg_restore pouzit iny port pre dalsi loadbalancer v tomto file
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
          max_client_conn      = "100"
          default_pool_size    = "20"
          server_idle_timeout  = "1800"
          server_lifetime      = "7200"
          query_timeout        = "300"
          client_idle_timeout  = "0"
        }
      }
    }
  }
}

# Direct PostgreSQL access (bypassing pgbouncer) for admin operations
# resource "kubernetes_service" "postgres_external" {
#   depends_on = [helm_release.postgres_cluster]

#   metadata {
#     name      = "${var.cluster_name}-external"
#     namespace = var.namespace
#     labels = {
#       "app.kubernetes.io/name"     = "postgres-external"
#       "app.kubernetes.io/instance" = var.cluster_name
#     }
#     annotations = {
#       "description" = "Direct PostgreSQL access for pg_restore, migrations, and admin operations"
#     }
#   }

#   spec {
#     type = "LoadBalancer"

#     selector = {
#       "cnpg.io/cluster"     = var.cluster_name
#       "cnpg.io/instanceRole" = "primary"
#     }

#     port {
#       name        = "postgres"
#       port        = 5432
#       target_port = 5432
#       protocol    = "TCP"
#     }

#     session_affinity = "ClientIP"
#   }
# }
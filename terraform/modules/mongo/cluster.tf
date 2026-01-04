resource "kubernetes_service_account" "mongodb_database" {
  depends_on = [kubernetes_namespace.mongodb_cluster_namespace]

  metadata {
    name      = "mongodb-database"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "mongodb_database" {
  metadata {
    name = "mongodb-database"
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "create", "update", "delete", "watch", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "create", "update", "delete", "watch", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "create", "update", "delete", "watch", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch", "patch", "update"]  # Added patch and update
  }

  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets"]
    verbs      = ["get", "list", "create", "update", "delete", "watch", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "create", "update", "delete", "watch", "patch"]  # Added for PVC management
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]  # Added for event creation
  }
}

resource "kubernetes_cluster_role_binding" "mongodb_database" {
  metadata {
    name = "mongodb-database"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.mongodb_database.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.mongodb_database.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_namespace" "mongodb_cluster_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_manifest" "mongodb_cluster" {
  depends_on = [kubernetes_secret.mongodb_cluster_admin_password, kubernetes_namespace.mongodb_cluster_namespace, kubernetes_service_account.mongodb_database]

  manifest = {
    apiVersion = "mongodbcommunity.mongodb.com/v1"
    kind       = "MongoDBCommunity"
    metadata = {
      name      = var.cluster_name
      namespace = var.namespace
    },
    spec = {
      members = var.spec.replica_count
      type    = "ReplicaSet"
      version = var.spec.version
      security = {
        authentication = {
          modes = ["SCRAM"]
        }
      }

      statefulSet = {
        spec = {
          volumeClaimTemplates = [
            {
              metadata = {
                name = "data-volume"
              }
              spec = {
                accessModes = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = var.persistence.data.storage_size
                  }
                }
              }
            },
            {
              metadata = {
                name = "logs-volume"
              }
              spec = {
                accessModes = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = var.persistence.logs.storage_size
                  }
                }
              }
            }
          ]

          template = {
            spec = {
              containers = [
                {
                  name = "mongod"
                  resources = {
                    limits = {
                      cpu    = var.resource.limits.cpu
                      memory = var.resource.limits.memory
                    }
                    requests = {
                      cpu    = var.resource.requests.cpu
                      memory = var.resource.requests.memory
                    }
                  }
                },
                {
                  name = "mongodb-agent"
                  resources = {
                    limits = {
                      cpu    = "0.25"
                      memory = "128Mi"
                    }
                    requests = {
                      cpu    = "0.1"
                      memory = "48Mi"
                    }
                  }
                }
              ]
            }
          }
        }
      }

      users = [
        {
          name = "admin"
          db   = "admin"
          passwordSecretRef = {
            name = "${var.cluster_name}-admin-password"
          }
          roles = [
            {
              name = "clusterAdmin"
              db   = "admin"
            },
            {
              name = "userAdminAnyDatabase"
              db   = "admin"
            },
            {
              name = "readWriteAnyDatabase"
              db   = "admin"
            },
            {
              name = "dbAdminAnyDatabase"
              db   = "admin"
            }
          ]
          scramCredentialsSecretName = "${var.cluster_name}-admin-scram"
        }
      ]
      additionalMongodConfig = {
        "storage.wiredTiger.engineConfig.journalCompressor" = "zlib"
      }
    }
  }
}

resource "kubernetes_secret" "mongodb_cluster_admin_password" {
  depends_on = [kubernetes_namespace.mongodb_cluster_namespace]

  metadata {
    name      = "${var.cluster_name}-admin-password"
    namespace = var.namespace
  }
  data = {
    password = var.admin_password
  }
}

resource "kubernetes_service" "mongodb_external" {
  metadata {
    name      = "${var.cluster_name}-external"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "${var.cluster_name}-svc"
    }

    port {
      name        = "mongodb"
      port        = 27017
      target_port = 27017
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_manifest.mongodb_cluster]
}

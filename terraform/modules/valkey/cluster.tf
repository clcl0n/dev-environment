resource "kubernetes_namespace" "valkey_cluster_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service" "valkey_loadbalancer" {
  depends_on = [kubernetes_namespace.valkey_cluster_namespace, kubernetes_manifest.valkey_cluster]

  metadata {
    name = "valkey-loadbalancer"
    namespace = var.namespace
  }

  spec {
    selector = {
      "valkey.io/cluster" = var.cluster_name
    }

    port {
      port = 6379
      target_port = 6379
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_manifest" "valkey_cluster" {
  depends_on = [ kubernetes_namespace.valkey_cluster_namespace ]

  manifest = {
    apiVersion = "valkey.io/v1alpha1"
    kind = "ValkeyCluster"
    metadata = {
      name = var.cluster_name
      namespace = var.namespace
    }
    spec = {
      replicas = 0
      shards = 1
      resources = {
        requests = {
          memory = var.resources.requests.memory
          cpu = var.resources.requests.cpu
        }
        limits = {
          memory = var.resources.limits.memory
          cpu = var.resources.limits.cpu
        }
      }
      users = [
        {
          name = "admin"
          nopass = true
          permissions = "+@all ~* &*"
        }
      ]
    }
  }
}

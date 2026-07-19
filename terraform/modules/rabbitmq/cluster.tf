resource "kubernetes_namespace" "rabbitmq_cluster_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "rabbitmq_cluster_default_user" {
  depends_on = [kubernetes_namespace.rabbitmq_cluster_namespace]

  metadata {
    name      = "${var.cluster_name}-default-user"
    namespace = var.namespace
  }

  data = {
    username = var.auth.username
    password = var.auth.password
  }
}

resource "kubernetes_manifest" "rabbitmq_cluster" {
  depends_on = [kubernetes_secret.rabbitmq_cluster_default_user]

  manifest = {
    apiVersion = "rabbitmq.com/v1beta1"
    kind       = "RabbitmqCluster"
    metadata = {
      name      = var.cluster_name
      namespace = var.namespace
    }
    spec = {
      replicas = var.resource.replica_count
      image    = "rabbitmq:${var.image.tag}"
      service = {
        type = "LoadBalancer"
      }
      persistence = {
        storage = var.persistence.size
      }
      resources = {
        requests = {
          cpu    = var.resource.requests.cpu
          memory = var.resource.requests.memory
        }
        limits = {
          cpu    = var.resource.limits.cpu
          memory = var.resource.limits.memory
        }
      }
    }
  }
}

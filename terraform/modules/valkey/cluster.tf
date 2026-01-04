resource "helm_release" "redis_cluster" {
  name             = var.cluster_name
  namespace        = var.namespace
  create_namespace = true
  chart            = "valkey"
  repository       = "oci://registry-1.docker.io/cloudpirates"
  version          = "0.3.2"

  values = [
    <<EOT
image:
  tag: ${var.image.tag}
replicaCount: 1
auth:
  enabled: true
  password: ${var.auth.password}
service:
  type: LoadBalancer
  port: 6379
  targetPort: 6379
persistence:
  enabled: true
  size: ${var.persistence.size}
resources:
  requests:
    memory: ${var.resources.requests.memory}
    cpu: ${var.resources.requests.cpu}
  limits:
    memory: ${var.resources.limits.memory}
    cpu: ${var.resources.limits.cpu}
EOT
  ]
}

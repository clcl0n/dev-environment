resource "helm_release" "rabbitmq_cluster" {
  name             = var.cluster_name
  namespace        = var.namespace
  create_namespace = true
  chart            = "rabbitmq"
  repository       = "oci://registry-1.docker.io/cloudpirates"
  version          = "0.2.11"

  values = [
    <<EOF
replicaCount: 1
image:
  tag: ${var.image.tag}
  imagePullPolicy: "IfNotPresent"
service:
  type: LoadBalancer
  amqpPort: 5672
  managementPort: 15672
auth:
  enabled: true
  username: ${var.auth.username}
  password: ${var.auth.password}
metrics:
  enabled: true
persistence:
  enabled: true
  size: ${var.persistence.size}
resources:
  requests:
    cpu: ${var.resource.requests.cpu}
    memory: ${var.resource.requests.memory}
  limits:
    cpu: ${var.resource.limits.cpu}
    memory: ${var.resource.limits.memory}
EOF
  ]
}
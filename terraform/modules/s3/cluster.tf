resource "helm_release" "s3_cluster" {
  name             = var.cluster_name
  namespace        = var.namespace
  create_namespace = true
  chart            = "minio"
  repository       = "oci://registry-1.docker.io/cloudpirates"
  version          = "0.2.3"

  values = [
    <<EOT
replicaCount: 1
image:
  tag: "${var.image.tag}"
auth:
  rootUser: ${var.auth.rootUser}
  rootPassword: ${var.auth.rootPassword}
service:
  type: LoadBalancer
  port: 9000
  portConsole: 9090
persistence:
  enabled: true
  size: "${var.persistence.size}"
resources:
  requests:
    memory: "${var.resources.requests.memory}"
    cpu: "${var.resources.requests.cpu}"
  limits:
    memory: "${var.resources.limits.memory}"
    cpu: "${var.resources.limits.cpu}"
EOT
  ]
}

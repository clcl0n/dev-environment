resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = true
  namespace        = var.namespace
  version          = "77.10.0"

  values = [
    <<EOT
global:
  rbac:
    create: true
    pspEnabled: false

prometheus:
  enabled: true
  prometheusSpec:
    retention: "14d"
    storageSpec:
      volumeClaimTemplate:
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: ${var.prometheus.resources.storage_size}
    resources:
      requests:
        memory: "${var.prometheus.resources.requests.memory}"
        cpu: "${var.prometheus.resources.requests.cpu}"
      limits:
        memory: "${var.prometheus.resources.limits.memory}"
        cpu: "${var.prometheus.resources.limits.cpu}"

alertmanager:
  enabled: false

grafana:
  enabled: true
  adminUser: "${var.grafana.admin_user}"
  adminPassword: "${var.grafana.admin_password}"
  persistence:
    enabled: true
    size: "${var.grafana.resources.storage_size}"
  resources:
    requests:
      memory: "${var.grafana.resources.requests.memory}"
      cpu: "${var.grafana.resources.requests.cpu}"
    limits:
      memory: "${var.grafana.resources.limits.memory}"
      cpu: "${var.grafana.resources.limits.cpu}"
  service:
    type: LoadBalancer
    port: 3000

nodeExporter:
  enabled: true

kubeStateMetrics:
  enabled: true

prometheusOperator:
  enabled: true
  tls:
    enabled: false
  admissionWebhooks:
    enabled: false
  serviceMonitor:
    selfMonitor: true
EOT
  ]

}
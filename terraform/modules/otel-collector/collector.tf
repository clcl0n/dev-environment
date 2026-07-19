resource "helm_release" "mongo_cluster" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  chart            = "opentelemetry-collector"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  version          = var.chart_version

  values = [
    <<EOT
mode: statefulset
image:
  repository: "otel/opentelemetry-collector-contrib"
service:
    enabled: true
    type: LoadBalancer
resources:
    requests:
        memory: ${var.resource.requests.memory}
        cpu: ${var.resource.requests.cpu}
    limits:
        memory: ${var.resource.limits.memory}
        cpu: ${var.resource.limits.cpu}
config:
    exporters:
        otlp/elastic:
            endpoint: ${var.apm_url}
            headers:
                Authorization: Bearer ${var.apm_token}
            tls:
                insecure: false
                insecure_skip_verify: true
    processors:
        batch: {}
    receivers:
        otlp:
            protocols:
                grpc:
                    endpoint: 0.0.0.0:4317
                http:
                    endpoint: 0.0.0.0:4318
    service:
        pipelines:
            logs:
                exporters:
                - otlp/elastic
                processors:
                - batch
                receivers:
                - otlp
            metrics:
                exporters:
                - otlp/elastic
                processors:
                - batch
                receivers:
                - otlp
            traces:
                exporters:
                - otlp/elastic
                processors:
                - batch
                receivers:
                - otlp
EOT
  ]
}

resource "kubernetes_namespace" "es_cluster_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "es_user_secret" {
  depends_on = [kubernetes_namespace.es_cluster_namespace]

  metadata {
    name      = "es-es-elastic-user"
    namespace = var.namespace
  }

  data = {
    elastic = var.elasticsearch.password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "apm_token_secret" {
  depends_on = [kubernetes_namespace.es_cluster_namespace]

  metadata {
    namespace = var.namespace
    name      = "apm-apm-token"
  }

  data = {
    secret-token = var.apm.secret_token
  }

  type = "Opaque"
}

resource "helm_release" "eck_cluster" {
  depends_on = [kubernetes_namespace.es_cluster_namespace]

  name = var.cluster_name
  namespace = var.namespace
  create_namespace = true
  chart = "eck-stack"
  repository = "https://helm.elastic.co"

  values = [
    <<EOT
eck-elasticsearch:
  enabled: true
  # This is adjusting the full name of the elasticsearch resource so that both the eck-elasticsearch
  # and the eck-kibana chart work together by default in the eck-stack chart.
  fullnameOverride: es
  # version: 9.0.0
  nodeSets:
  - name: default
    count: 1
    config:
      node.store.allow_mmap: false
      # reindex.remote.whitelist: "nmh-dam-production-es8.es.europe-west3.gcp.cloud.es.io:9243"
    podTemplate:
      spec:
        initContainers:
          - name: install-plugins
            command:
              - sh
              - -c
              - |
                bin/elasticsearch-plugin install --batch analysis-icu
        containers:
          - name: elasticsearch
            resources:
              limits:
                cpu: ${var.elasticsearch.resources.limits.cpu}
                memory: ${var.elasticsearch.resources.limits.memory}
              requests:
                cpu: ${var.elasticsearch.resources.requests.cpu}
                memory: ${var.elasticsearch.resources.requests.memory}
    volumeClaimTemplates:
    - metadata:
        name: elasticsearch-data
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: ${var.elasticsearch.persistence.storage_size}

# If enabled, will use the eck-kibana chart and deploy a Kibana resource.
#
eck-kibana:
  enabled: true
  # version: 9.0.0
  fullnameOverride: kb
  spec:
    http:
      service:
        spec:
          type: LoadBalancer
    # This is also adjusting the kibana reference to the elasticsearch resource named previously so that
    # both the eck-elasticsearch and the eck-kibana chart work together by default in the eck-stack chart.
  elasticsearchRef:
    name: es

# If enabled, will use the eck-agent chart and deploy an Elastic Agent instance.
#
eck-agent:
  enabled: false

# If enabled, will use the eck-fleet-server chart and deploy a Fleet Server resource.
#
eck-fleet-server:
  enabled: false

# If enabled, will use the eck-beats chart and deploy a Beats resource.
#
eck-beats:
  enabled: false

# If enabled, will use the eck-logstash chart and deploy a Logstash resource.
#
eck-logstash:
  enabled: false

# If enabled, will use the eck-apm-server chart and deploy a standalone APM Server resource.
#
eck-apm-server:
  enabled: true
  # version: 9.0.0
  fullnameOverride: apm
  elasticsearchRef:
    name: es
  kibanaRef:
    name: kb

# If enabled, will use the eck-enterprise-search chart and deploy a Enterprise Search resource.
#
eck-enterprise-search:
  enabled: false
EOT
  ]
}

resource "kubernetes_service" "es_loadbalancer" {
  depends_on = [helm_release.eck_cluster, kubernetes_namespace.es_cluster_namespace]

  metadata {
    name = "es-es-loadbalancer"
    namespace = var.namespace
  }

  spec {
    selector = {
      "elasticsearch.k8s.elastic.co/cluster-name" = "es"
    }

    port {
      port = 9200
      target_port = 9200
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "apm_loadbalancer" {
  depends_on = [helm_release.eck_cluster, kubernetes_namespace.es_cluster_namespace]

  metadata {
    name = "apm-apm-loadbalancer"
    namespace = var.namespace
  }

  spec {
    selector = {
      "apm.k8s.elastic.co/name" = "apm"
    }

    port {
      port = 8200
      target_port = 8200
    }

    type = "LoadBalancer"
  }
}
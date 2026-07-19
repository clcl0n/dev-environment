module "eck" {
  source = "./modules/eck"
  cluster_name = var.eck.cluster_name
  namespace = var.eck.namespace
  spec = var.eck.spec
  elasticsearch = var.eck.elasticsearch
  apm = var.eck.apm
  kube_config_path = var.kube_config_path
}

module "grafana" {
  source = "./modules/grafana"
  namespace    = var.grafana.namespace
  cluster_name = var.grafana.cluster_name
  chart_version = var.grafana.chart_version
  prometheus = var.grafana.prometheus
  grafana = var.grafana.grafana
  kube_config_path = var.kube_config_path
}

module "mongo" {
  source = "./modules/mongo"
  namespace = var.mongo.namespace
  cluster_name = var.mongo.cluster_name
  spec = var.mongo.spec
  admin_password = var.mongo.admin_password
  persistence = var.mongo.persistence
  resource = var.mongo.resource
  kube_config_path = var.kube_config_path
}

module "otel-collector" {
  source = "./modules/otel-collector"
  name = var.otel_collector.name
  namespace = var.otel_collector.namespace
  apm_token = var.otel_collector.apm_token
  apm_url = var.otel_collector.apm_url
  image = var.otel_collector.image
  resource = var.otel_collector.resource
  kube_config_path = var.kube_config_path
}

module "postgres" {
  source = "./modules/postgres"
  namespace    = var.postgres.namespace
  cluster_name = var.postgres.cluster_name
  image = var.postgres.image
  persistence = var.postgres.persistence
  resources = var.postgres.resources
  database_superuser_name = var.postgres.database_superuser_name
  database_superuser_password = var.postgres.database_superuser_password
  kube_config_path = var.kube_config_path
}

module "rabbitmq" {
  source = "./modules/rabbitmq"
  namespace = var.rabbitmq.namespace
  cluster_name = var.rabbitmq.cluster_name
  image = var.rabbitmq.image
  auth = var.rabbitmq.auth
  persistence = var.rabbitmq.persistence
  resource = var.rabbitmq.resource
  kube_config_path = var.kube_config_path
}

module "s3" {
  source = "./modules/s3"
  namespace = var.s3.namespace
  cluster_name = var.s3.cluster_name
  image = var.s3.image
  auth = var.s3.auth
  persistence = var.s3.persistence
  resources = var.s3.resources
  kube_config_path = var.kube_config_path
}

module "valkey" {
  source = "./modules/valkey"
  namespace = var.valkey.namespace
  cluster_name = var.valkey.cluster_name
  image = var.valkey.image
  auth = var.valkey.auth
  persistence = var.valkey.persistence
  resources = var.valkey.resources
  kube_config_path = var.kube_config_path
}

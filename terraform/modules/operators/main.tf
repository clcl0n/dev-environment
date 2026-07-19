module "eck-operator" {
  source = "../eck-operator"
  namespace = var.eck_operator.namespace
  chart_version = var.eck_operator.chart_version
  kube_config_path = var.kube_config_path
}

module "mongo-operator" {
  source = "../mongo-operator"
  namespace = var.mongo_operator.namespace
  chart_version = var.mongo_operator.chart_version
  watch_namespace = var.mongo_operator.watch_namespace
  kube_config_path = var.kube_config_path
}

module "postgres-operator" {
  source = "../postgres-operator"
  namespace = var.postgres_operator.namespace
  chart_version = var.postgres_operator.chart_version
  kube_config_path = var.kube_config_path
}

module "rabbitmq-operator" {
  source = "../rabbitmq-operator"
  operator_version = var.rabbitmq_operator.version
  kube_config_path = var.kube_config_path
}

module "valkey-operator" {
  source = "../valkey-operator"
  namespace = var.valkey_operator.namespace
  chart_version = var.valkey_operator.chart_version
  kube_config_path = var.kube_config_path
}

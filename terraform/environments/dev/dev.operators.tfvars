eck_operator = {
  namespace     = "eck-operator"
  chart_version = "3.1.0"
}

mongo_operator = {
  namespace       = "mongo-operator"
  chart_version   = "1.9.1"
  watch_namespace = "mongo-cluster"
}

postgres_operator = {
  namespace     = "postgres-operator"
  chart_version = "0.29.0"
}

rabbitmq_operator = {
  version = "v2.22.3"
}

valkey_operator = {
  namespace     = "valkey-operator-system"
  chart_version = "0.3.0"
}

kube_config_path = "~/.kube/config"

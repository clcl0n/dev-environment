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
  chart_version = "0.26.0"
}

kube_config_path = "~/.kube/config"
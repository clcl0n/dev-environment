eck = {
  cluster_name = "elastic-cluster"
  namespace    = "elastic-cluster"
  spec = {
    version = "9.4.3"
  }
  elasticsearch = {
    password = "elastic"
    persistence = {
      storage_size = "20Gi"
    }
    resources = {
      requests = {
        cpu    = "3"
        memory = "8Gi"
      }
      limits = {
        cpu    = "3"
        memory = "8Gi"
      }
    }
  }
  apm = {
    secret_token = "apm-secret-token"
  }
}

grafana = {
  namespace    = "monitoring"
  cluster_name = "monitoring-cluster"
  chart_version = "87.16.1"
  prometheus = {
    resources = {
      storage_size = "15Gi"
      requests = {
        memory = "1Gi"
        cpu    = "500m"
      }
      limits = {
        memory = "1Gi"
        cpu    = "1000m"
      }
    }
  }
  grafana = {
    admin_user = "admin"
    admin_password = "admin123"
    resources = {
      storage_size = "5Gi"
      requests = {
        memory = "256Mi"
        cpu = "500m"
      }
      limits = {
        memory = "256Mi"
        cpu = "500m"
      }
    }
  }
}

mongo = {
  namespace = "mongo-cluster"
  cluster_name = "mongo-cluster"
  spec = {
    replica_count = 1
    version = "8.3.4"
  }
  admin_password = "admin"
  persistence = {
    data = {
      storage_size = "20Gi"
    }
    logs = {
      storage_size = "4Gi"
    }
  }
  resource = {
    replica_count = 1
    requests = {
      memory = "1Gi"
      cpu = "1"
    }
    limits = {
      memory = "2Gi"
      cpu = "1"
    }
  }
}

otel_collector = {
  name = "otel-collector"
  namespace = "otel-collector"
  chart_version = "0.165.0"
  apm_token = "apm-secret-token"
  apm_url = "apm-apm-http.elastic-cluster:8200"
  image = {
    tag = "0.15.0"
  }
  resource = {
    requests = {
      memory = "256Mi"
      cpu = "250m"
    }
    limits = {
      memory = "512Mi"
      cpu = "500m"
    }
  }
}

postgres = {
  namespace = "postgres-cluster"
  cluster_name = "postgres-cluster"
  chart_version = "0.8.0"
  database_superuser_name = "postgres"
  database_superuser_password = "postgres"
  image = {
    tag = "18.4"
  }
  persistence = {
    storage_size = "75Gi"
  }
  resources = {
    replica_count = 1
    requests = {
      memory = "5Gi"
      cpu = 4
    }
    limits = {
      memory = "5Gi"
      cpu = 4
    }
  }
}

rabbitmq = {
  namespace = "rabbitmq-cluster"
  cluster_name = "rabbitmq-cluster"
  image = {
    tag = "4.1.4-management"
  }
  auth = {
    username = "admin"
    password = "admin"
  }
  persistence = {
    size = "5Gi"
  }
  resource = {
    replica_count = 1
    requests = {
      memory = "2Gi"
      cpu = "1000m"
    }
    limits = {
      memory = "2Gi"
      cpu = "1000m"
    }
  }
}

s3 = {
  namespace = "s3-cluster"
  cluster_name = "s3-cluster"
  image = {
    tag = "RELEASE.2025-09-07T16-13-09Z"
  }
  auth = {
    rootUser = "admin"
    rootPassword = "admin-password"
  }
  persistence = {
    size = "10Gi"
  }
  resources = {
    requests = {
      memory = "1Gi"
      cpu = "1000m"
    }
    limits = {
      memory = "1Gi"
      cpu = "1000m"
    }
  }
}

valkey = {
  namespace = "valkey-cluster"
  cluster_name = "valkey-cluster"
  image = {
    tag = "8.1.3"
  }
  auth = {
    password = "default"
  }
  persistence = {
    size = "2Gi"
  }
  resources = {
    requests = {
      memory = "512Mi"
      cpu    = "512m"
    }
    limits = {
      memory = "512Mi"
      cpu    = "512m"
    }
  }
}

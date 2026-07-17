variable "eck" {
  type = object({
    cluster_name = string
    namespace = string
    spec = object({
      version = string
    })
    elasticsearch = object({
      password = string
      persistence = object({
        storage_size = string
      })
      resources = object({
        requests = object({
          cpu = string
          memory = string
        })
        limits = object({
          cpu = string
          memory = string
        })
      })
    })
    apm = object({
      secret_token = string
    })
  })
}

variable "grafana" {
  type = object({
    namespace = string
    cluster_name = string
    chart_version = string
    prometheus = object({
      resources = object({
        # replica_count = number
        storage_size = string
        requests = object({
          memory = string
          cpu = string
        })
        limits = object({
          memory = string
          cpu = string
        })
      })
    })
    grafana = object({
      admin_user = string
      admin_password = string
      resources = object({
        storage_size = string
        requests = object({
          memory = string
          cpu = string
        })
        limits = object({
          memory = string
          cpu = string
        })
      })
    })
  })
}

variable "mongo" {
  type = object({
    namespace = string
    cluster_name = string
    admin_password = string
    spec = object({
      replica_count = number
      version = string
    })
    persistence = object({
      data = object({
        storage_size = string
      })
      logs = object({
        storage_size = string
      })
    })
    resource = object({
      replica_count = number
      requests = object({
        memory = string
        cpu = string
      })
      limits = object({
        memory = string
        cpu = string
      })
    })
  })
}

variable "otel_collector" {
  type = object({
    namespace = string
    name = string
    apm_token = string
    apm_url = string
    image = object({
      tag = string
    })
    resource = object({
      requests = object({
        memory = string
        cpu = string
      })
      limits = object({
        memory = string
        cpu = string
      })
    })
  })
}

variable "postgres" {
  type = object({
    namespace = string
    cluster_name = string
    database_superuser_name = string
    database_superuser_password = string
    image = object({
      tag = string
    })
    persistence = object({
      storage_size = string
    })
    resources = object({
      replica_count = number
      requests = object({
        memory = string
        cpu = number
      })
      limits = object({
        memory = string
        cpu = number
      })
    })
  })
}

variable "rabbitmq" {
  type = object({
    namespace = string
    cluster_name = string
    image = object({
      tag = string
    })
    auth = object({
      username = string
      password = string
    })
    persistence = object({
      size = string
    })
    resource = object({
      replica_count = number
      requests = object({
        memory = string
        cpu = string
      })
      limits = object({
        memory = string
        cpu = string
      })
    })
  })
}

variable "s3" {
  type = object({
    namespace = string
    cluster_name = string
    image = object({
      tag = string
    })
    auth = object({
      rootUser = string
      rootPassword = string
    })
    persistence = object({
      size = string
    })
    resources = object({
      requests = object({
        memory = string
        cpu = string
      })
      limits = object({
        memory = string
        cpu = string
      })
    })
  })
}

variable "valkey" {
  type = object({
    namespace = string
    cluster_name = string
    auth = object({
      password = string
    })
    image = object({
      tag = string
    })
    persistence = object({
      size = string
    })
    resources = object({
      requests = object({
        memory = string
        cpu = string
      })
      limits = object({
        memory = string
        cpu   = string
      })
    })
  })
}

variable "kube_config_path" {
  type = string
  default = "~/.kube/config"
}
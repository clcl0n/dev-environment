variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "namespace" {
  description = "Namespace for PostgreSQL resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the PostgreSQL cluster"
  type        = string
}

variable "chart_version" {
  type = string
}

variable "prometheus" {
  type = object({
    resources = object({
      storage_size = string
      requests = object({
        memory = string
        cpu    = string
      })
      limits = object({
        memory = string
        cpu    = string
      })
    })
  })
}

variable "grafana" {
  type = object({
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
}
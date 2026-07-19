variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "spec" {
  type = object({
    replica_count = number
    version       = string
  })
}

variable "admin_password" {
  type = string
}

variable "persistence" {
  type = object({
    data = object({
      storage_size = string
    })
    logs = object({
      storage_size = string
    })
  })
}

variable "resource" {
  type = object({
    replica_count = number
    requests = object({
      memory = string
      cpu    = string
    })
    limits = object({
      memory = string
      cpu    = string
    })
  })
}

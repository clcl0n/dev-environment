variable "kube_config_path" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "elasticsearch" {
  type = object({
    password = string
    persistence = object({
      storage_size = string
    })
    resources = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
  })
}

variable "apm" {
  type = object({
    secret_token = string
  })
}
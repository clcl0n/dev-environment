variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "image" {
  type = object({
    tag = string
  })
}

variable "auth" {
  type = object({
    username = string
    password = string
  })
}

variable "persistence" {
  type = object({
    size = string
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
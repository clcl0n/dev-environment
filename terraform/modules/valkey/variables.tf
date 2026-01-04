variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "auth" {
  type = object({
    password = string
  })
}

variable "image" {
  type = object({
    tag = string
  })
}

variable "persistence" {
  type = object({
    size = string
  })
}

variable "resources" {
  type = object({
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
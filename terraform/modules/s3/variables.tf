variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "cluster_name" {
  description = "Name of the PostgreSQL cluster"
  type = string
}

variable "namespace" {
  description = "Namespace for PostgreSQL resources"
  type = string
}

variable "image" {
  type = object({
    tag = string
  })
}

variable "auth" {
  type = object({
    rootUser = string
    rootPassword = string
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
      cpu = string
    })
    limits = object({
      memory = string
      cpu = string
    })
  })
}
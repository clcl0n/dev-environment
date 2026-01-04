variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type = string
}

variable "namespace" {
  description = "Namespace for PostgreSQL resources"
  type = string
}

variable "cluster_name" {
  description = "Name of the PostgreSQL cluster"
  type = string
}

variable "image" {
  type = object({
    tag = string
  })
}

variable "persistence" {
  type = object({
    storage_size = string
  })
}

variable "resources" {
  type = object({
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
}

variable "database_superuser_name" {
  description = "Username for the database owner"
  type = string
  default = "postgres"
}

variable "database_superuser_password" {
  description = "Password for the database owner"
  type = string
  sensitive = true
}
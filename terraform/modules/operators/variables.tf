variable "eck_operator" {
  type = object({
    namespace = string
    chart_version = string
  })
}

variable "mongo_operator" {
  type = object({
    namespace       = string
    chart_version   = string
    watch_namespace = string
  })
}

variable "postgres_operator" {
  type = object({
    namespace = string
    chart_version = string
  })
}

variable "rabbitmq_operator" {
  type = object({
    version = string
  })
}

variable "kube_config_path" {
  type = string
}
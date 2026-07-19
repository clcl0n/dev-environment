variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "chart_version" {
  type = string
}

variable "apm_url" {
  type    = string
}

variable "apm_token" {
  type = string
}

variable "resource" {
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

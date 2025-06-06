variable "civo_token" {
  description = "Token da API do Civo"
  type        = string
}

variable "firewall_id" {
  description = "ID do firewall do cluster, ex: default-default"
  type        = string
}

variable "network_id" {
  type = string
}

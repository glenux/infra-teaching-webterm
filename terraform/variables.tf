
variable "mongo_gateways_enable" {
  default = false
  type = bool
}

variable "mongo_servers_enable" {
  default = false
  type = bool
}

variable "mongo_groups_count" {
  default     = "1"
  description = "How many replicas per mongo"
}

variable "mongo_replicas_count" {
  default     = "2"
  description = "How many replicas per mongo group"
}

variable "ssh_private_key" {}

variable "ssh_public_key" {}

variable "gandi_key" {}

variable "domain_name" {}

variable "subdomain_suffix" {
}

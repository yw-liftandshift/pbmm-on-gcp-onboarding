
variable "associations" {
  description = "List of firewall endpoint associations to create."
  type = list(object({
    name                 = string
    region               = string
    firewall_endpoint_id = string
  }))
}

variable "project_id" {
  description = "Base project id."
  type        = string
}

variable "network_name" {
  description = "Base network name."
  type        = string
}


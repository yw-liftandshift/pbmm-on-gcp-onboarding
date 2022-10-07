variable "firewall_policies" {
  description = "Hierarchical firewall policies created in this folder."
  type = map(map(object({
    action                  = string
    description             = string
    direction               = string
    logging                 = bool
    ports                   = map(list(string))
    priority                = number
    ranges                  = list(string)
    target_resources        = list(string)
    target_service_accounts = list(string)
  })))
  default  = {}
}

variable "firewall_policy_association" {
  description = "The hierarchical firewall policy to associate to this folder. Must be either a key in the `firewall_policies` map or the id of a policy defined somewhere else."
  type        = map(string)
  default     = {}
}

variable "firewall_policy_factory" {
  description = "Configuration for the firewall policy factory."
  type = object({
    cidr_file   = string
    policy_name = string
    rules_file  = string
  })
  default = null
}

variable "folder_create" {
  description = "Create folder. When set to false, uses id to reference an existing folder."
  type        = bool
  default     = false
}
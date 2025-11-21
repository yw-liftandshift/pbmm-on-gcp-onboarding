variable "project_name" {
  description = "The name of the project to be created."
  type        = string

}

variable "editor_group" {
  description = "The email of the group that will be granted editor roles."
  type        = list(string)
}

variable "admin_group" {
  description = "The email of the group that will be granted admin roles."
  type        = list(string)
  default     = []
}


variable "identity_domain" {
  description = "The domain associated with the Google Workspace / Cloud Identity account."
  type        = string
}


variable "metadata" {
  description = "Metadata to be associated with the project."
  type = object({
    type             = string
    data_classification = string
  })
  default     = {
    type = "client"
    data_classification = "unclass"
  }
}

variable "billing_account" {
  description = "The billing account to be associated with the project."
  type        = string
}

variable "folder" {
  description = "The folder ID where the project will be created."
  type        = string
}

variable "project_prefix" {
  description = "The prefix for the project ID."
  type        = string
}

variable "regions" {
  description = "The regions for subnets."
  type        = list(string)
}

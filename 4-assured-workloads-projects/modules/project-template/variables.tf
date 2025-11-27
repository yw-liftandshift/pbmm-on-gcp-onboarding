/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
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

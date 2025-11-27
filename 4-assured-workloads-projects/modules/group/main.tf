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
 
 
 variable group_name {
  description = "The name of the group to be created."
  type        = string
}

variable group_description {
  description = "The description of the group."
  type        = string
}

variable members {
  description = "The members of the group."
  type        = list(string)
}

variable directory_customer_id {
  description = "The customer ID of the Google Workspace / Cloud Identity account."
  type        = string
}

variable identity_domain {
  description = "The identity domain for the group."
  type        = string
}

resource "google_cloud_identity_group" "cloud_identity_groups" {

  display_name         = var.group_name
  description          = var.group_description
  initial_group_config = "WITH_INITIAL_OWNER"

  parent = "customers/${var.directory_customer_id}"

  group_key {
      id = "${var.group_name}@${var.identity_domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }

}

resource "google_cloud_identity_group_membership" "cloud_identity_group_membership" {

  for_each = toset(var.members)

  group = google_cloud_identity_group.cloud_identity_groups.name

  preferred_member_key {
    id = "${each.key}@${var.identity_domain}"
  }

  roles {
    name = "MEMBER"
  }
}
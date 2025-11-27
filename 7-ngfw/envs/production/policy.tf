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
 
 data "google_compute_network" "base_network" {
  name    = local.base_network_name
  project = local.base_host_project_id
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_compute_firewall_policy" "default" {
  parent      = local.parent_folder
  short_name  = "test-policy-${random_id.suffix.hex}"
  description = "Test policy"
}

data "google_compute_addresses" "nat_addresses" {
  filter  = "name:ca-*"
  project = local.base_host_project_id
}

locals {
  # get array of just the ip addresses
  nat_ip_addresses = data.google_compute_addresses.nat_addresses.addresses[*].address
}

resource "google_compute_firewall_policy_rule" "primary" {
  firewall_policy = google_compute_firewall_policy.default.id
  description     = "Firewall policy rule L7"
  priority        = 6000
  enable_logging  = true
  direction       = "INGRESS"
  disabled        = false

  action                 = "apply_security_profile_group"
  security_profile_group = local.security_profile_group.id

  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["80", "443"]

    }
    src_ip_ranges = local.nat_ip_addresses

  }

}

resource "google_compute_firewall_policy_rule" "primary2" {
  firewall_policy = google_compute_firewall_policy.default.id
  description     = "Firewall policy rule L7 (test 2)"
  priority        = 7000
  enable_logging  = true
  action          = "allow"
  direction       = "INGRESS"
  disabled        = false

  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["80", "443"]

    }
    src_ip_ranges = local.nat_ip_addresses

  }

}


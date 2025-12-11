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
 
 
resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_network_security_security_profile" "security_profile" {
  name     = "sec-profile-${random_id.suffix.hex}"
  type     = "THREAT_PREVENTION"
  parent   = "organizations/${local.org_id}"
  location = "global"
}

resource "google_network_security_security_profile_group" "default" {
  name                      = "sec-profile-group-${random_id.suffix.hex}"
  parent                    = "organizations/${local.org_id}"
  description               = "Security profile group"
  threat_prevention_profile = google_network_security_security_profile.security_profile.id

  labels = {
    key1 = "value1"
    key2 = "value2"
  }
}

resource "google_project_service" "project" {
  project = local.seed_project_id
  service = "networksecurity.googleapis.com"
}

resource "google_network_security_firewall_endpoint" "default_1" {
  count = 1
  name               = "firewall-endpoint"
  parent             = "organizations/${local.org_id}"
  location           = "${local.default_region}-a"
  billing_project_id = local.base_host_project_id

}

resource "google_network_security_firewall_endpoint" "default_2" {
  count = 1
  name               = "firewall-endpoint"
  parent             = "organizations/${local.org_id}"
  location           = "${local.default_region}-b"
  billing_project_id = local.base_host_project_id
}

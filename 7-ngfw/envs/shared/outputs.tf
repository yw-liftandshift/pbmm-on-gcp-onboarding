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
 
 output "firewall_endpoint_1" {
  description = "Firewall endpoint 1."
  value = try(google_network_security_firewall_endpoint.default_1[0], {})
}

output "firewall_endpoint_2" {
  description = "Firewall endpoint 2."
  value = try(google_network_security_firewall_endpoint.default_2[0], {})
}

output "security_profile_group" {
  description = "Security profile group."
  value       = google_network_security_security_profile_group.default
}


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
 
 resource "google_compute_network" "vpc_network" {
  name                    = local.vpc_name
  project            = google_project.main.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet_a" {
  name                     = "subnet-a"
  project            = google_project.main.project_id
  ip_cidr_range            = "10.0.1.0/24"
  region                   = var.regions[0]
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true # Required for VPC SC internal comms
}

resource "google_compute_subnetwork" "subnet_b" {
  name                     = "subnet-b"
  project            = google_project.main.project_id
  ip_cidr_range            = "10.0.2.0/24"
  region                   = var.regions[1]
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}


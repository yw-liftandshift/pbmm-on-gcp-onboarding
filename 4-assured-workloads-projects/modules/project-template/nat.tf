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

/******************************************
  NAT Cloud Router & NAT config
 *****************************************/

resource "google_compute_router" "nat_router_region1" {
  name    = "cr-${local.vpc_name}-${var.regions[0]}-nat-router"
  project = google_project.main.project_id
  region  = var.regions[0]
  network = google_compute_network.vpc_network.name

}

resource "google_compute_address" "nat_external_addresses_region1" {
  project = google_project.main.project_id
  name    = "ca-${local.vpc_name}-1"
  region  = var.regions[0]
}

resource "google_compute_router_nat" "egress_nat_region1" {

  name                               = "rn-${local.vpc_name}-${var.regions[0]}-egress"
  project                            = google_project.main.project_id
  router                             = google_compute_router.nat_router_region1.name
  region                             = var.regions[0]
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_external_addresses_region1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_router" "nat_router_region2" {

  name    = "cr-${local.vpc_name}-${var.regions[1]}-nat-router"
  project = google_project.main.project_id
  region  = var.regions[1]
  network = google_compute_network.vpc_network.name

}

resource "google_compute_address" "nat_external_addresses_region2" {
  project = google_project.main.project_id
  name    = "ca-${local.vpc_name}-2"
  region  = var.regions[1]
}

resource "google_compute_router_nat" "egress_nat_region2" {

  name                               = "rn-${local.vpc_name}-${var.regions[1]}-egress"
  project                            = google_project.main.project_id
  router                             = google_compute_router.nat_router_region2.name
  region                             = var.regions[1]
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_external_addresses_region2.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

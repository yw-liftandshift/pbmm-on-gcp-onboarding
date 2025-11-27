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
 

resource "google_project" "kms_project" {
  name                = "${local.project_prefix}-kms"
  project_id          = "${local.project_prefix}-kms-${random_string.suffix.result}"
  folder_id           = google_assured_workloads_workload.folder_pb.resources[0].resource_id
  billing_account     = local.billing_account
  auto_create_network = false
  deletion_policy     = "DELETE"
}

resource "google_project_service" "kms_project_apis" {
  for_each           = toset(["logging.googleapis.com", "cloudkms.googleapis.com"])
  project            = google_project.kms_project.project_id
  service            = each.value
  disable_on_destroy = false
}

# Create key ring
resource "google_kms_key_ring" "keyring" {
  name     = "keyring-${local.project_prefix}"
  location = local.regions[0]
  project  = google_project.kms_project.project_id

}



# Cretae crypto key
resource "google_kms_crypto_key" "kms_key" {
  name            = "crypto_key-${local.project_prefix}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "10368000s" #120 days

  lifecycle {
    prevent_destroy = false ## For actual workload, change to true
  }
  depends_on = [google_kms_key_ring.keyring]
}
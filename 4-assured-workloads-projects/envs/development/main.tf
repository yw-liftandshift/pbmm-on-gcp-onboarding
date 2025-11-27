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
 

resource "google_folder" "folder" {
  display_name = "fldr-${local.folder_name}"
  parent       = local.parent_folder_name
}

resource "google_folder" "folder_unclass" {
  display_name = "fldr-${local.folder_name}-unclass"
  parent       = google_folder.folder.name
}


resource "google_project_service" "enable_api_aw" {
  service                    = "assuredworkloads.googleapis.com"
  project                    = google_project.dependency_project.project_id
  disable_on_destroy         = false
  disable_dependent_services = false
  depends_on                 = [google_project.dependency_project]
}

resource "google_assured_workloads_workload" "folder_pb" {
  compliance_regime         = "CA_PROTECTED_B"
  display_name              = "fldr-${local.folder_name}-pb-${random_string.suffix.result}"
  location                  = "ca"
  organization              = local.organization
  billing_account           = "billingAccounts/${local.billing_account}"
  enable_sovereign_controls = true

  provisioned_resources_parent = google_folder.folder.name  

  resource_settings {
    resource_type = "CONSUMER_FOLDER"
  }

  provider                  = google-beta
  depends_on = [google_project_service.dependency_project_api] 
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "google_project" "dependency_project" {
  name                = "dep-${local.env}-${local.project_prefix}"
  project_id          = "dep-${local.env}-${local.project_prefix}-${random_string.suffix.result}"
  folder_id           = google_folder.folder.name
  billing_account     = local.billing_account
  auto_create_network = false
  deletion_policy     = "DELETE"
}


resource "google_project_service" "dependency_project_api" {

  project            = google_project.dependency_project.project_id
  service            = "assuredworkloads.googleapis.com"
  disable_on_destroy = false
}

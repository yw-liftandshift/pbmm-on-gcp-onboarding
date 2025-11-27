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

locals {

  editor_group = var.editor_group
  admin_group  = var.admin_group
  project_name = var.project_name

  vpc_name = "secure-vpc"

  project_id = "${var.project_prefix}-${local.project_name}"

  data_classification = var.metadata.data_classification
  project_type = var.metadata.type

  editor_roles = jsondecode(file("${path.module}/editor-roles.json")).roles
  admin_roles  = jsondecode(file("${path.module}/admin-roles.json")).roles

  apis_to_enable = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "aiplatform.googleapis.com",
    "bigquery.googleapis.com",
    "alloydb.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "dataplex.googleapis.com",
    "run.googleapis.com",
    "cloudfunctions.googleapis.com",
    "container.googleapis.com",
    "secretmanager.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "cloudscheduler.googleapis.com",
  ]

  editor_group_roles = flatten([
    for editor_group in local.editor_group : [
      for role in local.editor_roles : {
        key = "${editor_group}-${role}"
        member = "group:${editor_group}@${var.identity_domain}"
        role = role
      }
    ]
  ])

  admin_group_roles = flatten([
    for admin_group in local.admin_group : [
      for role in local.admin_roles : {
        key    = "${admin_group}-${role}"
        member = "group:${admin_group}@${var.identity_domain}"
        role   = role
      }
    ]
  ])
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "google_project" "main" {
  name                = local.project_name
  project_id          = "${local.project_name}-${random_string.suffix.result}"
  folder_id           = var.folder
  billing_account     = var.billing_account
  auto_create_network = false
}

resource "google_project_service" "apis" {
  for_each           = toset(local.apis_to_enable)
  project            = google_project.main.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_project_iam_member" "editor_group_bindings" {
  
  for_each = { for item in local.editor_group_roles: item.key => item }
  
  project  = google_project.main.project_id
  role     = each.value.role
  member   = each.value.member

  depends_on = [google_project_service.apis]
}

resource "google_project_iam_member" "admin_group_bindings" {

  for_each = { for item in local.admin_group_roles : item.key => item }

  project = google_project.main.project_id
  role    = each.value.role
  member  = each.value.member

  depends_on = [google_project_service.apis]
}


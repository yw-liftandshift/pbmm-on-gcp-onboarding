

locals {

  editor_group = var.editor_group
  project_name = var.project_name

  vpc_name = "secure-vpc"

  project_id = "${var.project_prefix}-${local.project_name}"

  data_classification = var.metadata.data_classification
  project_type = var.metadata.type

  editor_roles = [
    "roles/aiplatform.user",
    "roles/bigquery.user",
    "roles/alloydb.databaseUser",
    "roles/cloudsql.editor",
    "roles/storage.admin",
    "roles/storage.bucketViewer",
    "roles/compute.instanceAdmin",
    "roles/compute.networkUser",
    "roles/monitoring.editor",
    "roles/logging.viewer",
    "roles/cloudbuild.builds.editor",
    "roles/artifactregistry.writer",
    "roles/dataplex.editor",
    "roles/dataplex.catalogEditor",
    "roles/run.developer",
    "roles/cloudfunctions.developer",
    "roles/container.developer",
    "roles/secretmanager.admin",
    "roles/accesscontextmanager.policyEditor",
    "roles/cloudscheduler.admin",
  ]
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

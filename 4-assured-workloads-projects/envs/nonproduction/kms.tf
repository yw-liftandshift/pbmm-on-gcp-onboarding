

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
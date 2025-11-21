

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
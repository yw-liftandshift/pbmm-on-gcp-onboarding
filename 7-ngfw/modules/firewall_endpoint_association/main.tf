
resource "google_project_service" "base_service" {
  project = var.project_id
  service = "networksecurity.googleapis.com"

  disable_on_destroy = false
}

data "google_compute_network" "base_network" {
  name    = var.network_name
  project = var.project_id
}

resource "google_network_security_firewall_endpoint_association" "base_association" {
  for_each = { for association in var.associations : association.name => association }

  name              = each.value.name
  parent            = "projects/${var.project_id}"
  location          = each.value.region
  network           = data.google_compute_network.base_network.id
  firewall_endpoint = each.value.firewall_endpoint_id
  disabled          = false

  depends_on = [google_project_service.base_service]

}
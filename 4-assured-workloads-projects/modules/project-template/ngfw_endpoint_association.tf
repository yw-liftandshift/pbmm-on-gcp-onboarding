

data "terraform_remote_state" "ngfw_shared" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/cloud-firewall/shared"
  }
}
 
resource "google_project_service" "networksecurity_service" {
  project = google_project.main.project_id
  service = "networksecurity.googleapis.com"

  disable_on_destroy = false
}


resource "google_network_security_firewall_endpoint_association" "association_1" {

  name              = "fw-endpoint-assoc-1-${google_project.main.number}"
  parent            = "projects/${google_project.main.project_id}"
  location          = "${var.regions[0]}-a"
  network           = google_compute_network.vpc_network.id
  firewall_endpoint = data.terraform_remote_state.ngfw_shared.outputs.firewall_endpoint_1.id
  disabled          = false

  depends_on = [google_project_service.networksecurity_service]

}

resource "google_network_security_firewall_endpoint_association" "association_2" {

  name              = "fw-endpoint-assoc-2-${google_project.main.number}"
  parent            = "projects/${google_project.main.project_id}"
  location          = "${var.regions[0]}-b"
  network           = google_compute_network.vpc_network.id
  firewall_endpoint = data.terraform_remote_state.ngfw_shared.outputs.firewall_endpoint_2.id
  disabled          = false

  depends_on = [google_project_service.networksecurity_service]

}

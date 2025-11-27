
resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_network_security_security_profile" "security_profile" {
  name     = "sec-profile-${random_id.suffix.hex}"
  type     = "THREAT_PREVENTION"
  parent   = "organizations/${local.org_id}"
  location = "global"
}

resource "google_network_security_security_profile_group" "default" {
  name                      = "sec-profile-group-${random_id.suffix.hex}"
  parent                    = "organizations/${local.org_id}"
  description               = "Security profile group"
  threat_prevention_profile = google_network_security_security_profile.security_profile.id

  labels = {
    key1 = "value1"
    key2 = "value2"
  }
}

resource "google_project_service" "project" {
  project = local.seed_project_id
  service = "networksecurity.googleapis.com"
}

resource "google_network_security_firewall_endpoint" "default_1" {
  count = 1
  name               = "firewall-endpoint"
  parent             = "organizations/${local.org_id}"
  location           = "${local.default_region}-a"
  billing_project_id = local.base_host_project_id

}

resource "google_network_security_firewall_endpoint" "default_2" {
  count = 1
  name               = "firewall-endpoint"
  parent             = "organizations/${local.org_id}"
  location           = "${local.default_region}-b"
  billing_project_id = local.base_host_project_id
}

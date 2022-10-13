resource "google_compute_firewall" "subnet_links" {
  name    = "test-firewall"
  network = var.network

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  source_ranges = var.source_ips
  destination_ranges = var.destination_ips
}
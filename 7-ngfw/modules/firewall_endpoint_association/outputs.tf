output "associations" {
  description = "Firewall Endpoint Associations created"
  value       = google_network_security_firewall_endpoint_association.base_association
}
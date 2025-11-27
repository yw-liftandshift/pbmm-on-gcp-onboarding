output "firewall_endpoint_1" {
  description = "Firewall endpoint 1."
  value = try(google_network_security_firewall_endpoint.default_1[0], {})
}

output "firewall_endpoint_2" {
  description = "Firewall endpoint 2."
  value = try(google_network_security_firewall_endpoint.default_2[0], {})
}

output "security_profile_group" {
  description = "Security profile group."
  value       = google_network_security_security_profile_group.default
}


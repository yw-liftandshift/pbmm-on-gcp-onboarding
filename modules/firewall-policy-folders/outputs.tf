output "firewall-policy" {
  description = "Created policies"
  value       = google_compute_firewall_policy.policy
}
output "firewall-polic-rules" {
  description = "Created rules"
  value       = google_compute_firewall_policy_rule.rule
}

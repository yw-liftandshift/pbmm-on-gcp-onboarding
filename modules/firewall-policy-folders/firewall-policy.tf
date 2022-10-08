locals {
  _factory_cidrs = try(
    yamldecode(file(var.firewall_policy_factory.cidr_file)), {}
  )
  _factory_name = (
    try(var.firewall_policy_factory.policy_name, null) == null
    ? "factory"
    : var.firewall_policy_factory.policy_name
  )
  _factory_rules = try(
    yamldecode(file(var.firewall_policy_factory.rules_file)), {}
  )
  _factory_rules_parsed = {
    for name, rule in local._factory_rules : name => merge(rule, {
      ranges = flatten([
        for r in(rule.ranges == null ? [] : rule.ranges) :
        lookup(local._factory_cidrs, trimprefix(r, "$"), r)
      ])
    })
  }
  _merged_rules = flatten([
    for policy, rules in local.firewall_policies : [
      for name, rule in rules : merge(rule, {
        policy = policy
        name   = name
      })
    ]
  ])
  firewall_policies = merge(var.firewall_policies, (
    length(local._factory_rules) == 0
    ? {}
    : { (local._factory_name) = local._factory_rules_parsed }
  ))
  firewall_rules = {
    for r in local._merged_rules : "${r.policy}-${r.name}" => r
  }
}

resource "google_compute_firewall_policy" "policy" {
  for_each   = local.firewall_policies
  short_name = each.key
  parent     = var.folder_id
}

resource "google_compute_firewall_policy_rule" "rule" {
  for_each                = local.firewall_rules
  firewall_policy         = google_compute_firewall_policy.policy[each.value.policy].id
  action                  = each.value.action
  direction               = each.value.direction
  priority                = try(each.value.priority, null)
  target_resources        = try(each.value.target_resources, null)
  target_service_accounts = try(each.value.target_service_accounts, null)
  enable_logging          = try(each.value.logging, null)
  # preview                 = each.value.preview
  description = each.value.description
  match {
    src_ip_ranges  = each.value.direction == "INGRESS" ? each.value.ranges : null
    dest_ip_ranges = each.value.direction == "EGRESS" ? each.value.ranges : null
    dynamic "layer4_configs" {
      for_each = each.value.ports
      iterator = port
      content {
        ip_protocol = port.key
        ports       = port.value
      }
    }
  }
}

resource "google_compute_firewall_policy_association" "association" {
  for_each          = var.firewall_policy_association
  name              = "test"#replace(var.folder_id, "/", "-")
  attachment_target = var.folder_id
  firewall_policy   = try(google_compute_firewall_policy.policy[each.value].id, each.value)
}


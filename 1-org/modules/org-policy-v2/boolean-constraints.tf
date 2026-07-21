/******************************************
  Organization policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "org_policy_boolean" {
  provider = google-beta
  count    = local.organization && local.boolean_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  dynamic "spec" {
    for_each = length(local.rules) > 0 ? ["rules"] : []
    content {
      dynamic "rules" {
        for_each = local.rules
        content {
          enforce = rules.value.enforcement != false ? "TRUE" : "FALSE"
          # parameters = rules.value.parameters
          dynamic "condition" {
            for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
            content {
              description = condition.value.description
              expression  = condition.value.expression
              location    = condition.value.location
              title       = condition.value.title
            }
          }
        }
      }
    }
  }

  # dynamic "dry_run_spec" {
  #   for_each = length(local.rules_dry_run) > 0 ? ["dry_run_rules"] : []
  #   content {
  #     dynamic "rules" {
  #       for_each = local.rules_dry_run
  #       content {
  #         enforce    = rules.value.enforcement != false ? "TRUE" : "FALSE"
  #         parameters = rules.value.parameters
  #         dynamic "condition" {
  #           for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
  #           content {
  #             description = condition.value.description
  #             expression  = condition.value.expression
  #             location    = condition.value.location
  #             title       = condition.value.title
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

}

/******************************************
  Folder policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "folder_policy_boolean" {
  provider = google-beta
  count    = local.folder && local.boolean_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  dynamic "spec" {
    for_each = length(local.rules) > 0 ? ["rules"] : []
    content {
      dynamic "rules" {
        for_each = local.rules
        content {
          enforce = rules.value.enforcement != false ? "TRUE" : "FALSE"
          # parameters = rules.value.parameters
          dynamic "condition" {
            for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
            content {
              description = condition.value.description
              expression  = condition.value.expression
              location    = condition.value.location
              title       = condition.value.title
            }
          }
        }
      }
    }
  }

  # dynamic "dry_run_spec" {
  #   for_each = length(local.rules_dry_run) > 0 ? ["dry_run_rules"] : []
  #   content {
  #     dynamic "rules" {
  #       for_each = local.rules_dry_run
  #       content {
  #         enforce    = rules.value.enforcement != false ? "TRUE" : "FALSE"
  #         parameters = rules.value.parameters
  #         dynamic "condition" {
  #           for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
  #           content {
  #             description = condition.value.description
  #             expression  = condition.value.expression
  #             location    = condition.value.location
  #             title       = condition.value.title
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

}

/******************************************
  Project policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "project_policy_boolean" {
  provider = google-beta
  count    = local.project && local.boolean_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  dynamic "spec" {
    for_each = length(local.rules) > 0 ? ["rules"] : []
    content {
      dynamic "rules" {
        for_each = local.rules
        content {
          enforce = rules.value.enforcement != false ? "TRUE" : "FALSE"
          # parameters = rules.value.parameters
          dynamic "condition" {
            for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
            content {
              description = condition.value.description
              expression  = condition.value.expression
              location    = condition.value.location
              title       = condition.value.title
            }
          }
        }
      }
    }
  }

  # dynamic "dry_run_spec" {
  #   for_each = length(local.rules_dry_run) > 0 ? ["dry_run_rules"] : []
  #   content {
  #     dynamic "rules" {
  #       for_each = local.rules_dry_run
  #       content {
  #         enforce    = rules.value.enforcement != false ? "TRUE" : "FALSE"
  #         parameters = rules.value.parameters
  #         dynamic "condition" {
  #           for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
  #           content {
  #             description = condition.value.description
  #             expression  = condition.value.expression
  #             location    = condition.value.location
  #             title       = condition.value.title
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

}

/******************************************
  Exclude folders from policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "policy_boolean_exclude_folders" {
  provider = google-beta
  for_each = (local.boolean_policy && !local.project) ? var.exclude_folders : []

  name   = "${each.value}/policies/${var.constraint}"
  parent = each.value

  spec {
    rules {
      enforce = "FALSE"
    }
  }
}
/******************************************
  Exclude projects from policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "policy_boolean_exclude_projects" {
  provider = google-beta
  for_each = (local.boolean_policy && !local.project) ? var.exclude_projects : []

  name   = "${each.value}/policies/${var.constraint}"
  parent = each.value

  spec {
    rules {
      enforce = "FALSE"
    }
  }
}
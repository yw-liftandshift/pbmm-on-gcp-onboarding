# locals {
#   /**************************************************
#      Policy Exceptions
#     **************************************************/
#   /*
#     NOTE:
#     Please only use the maps below to add more exceptions.
#     Policy root must be : organization, folder or project
#     policy root id must be the id of the policy root (i.e organization id, folder id or project id) */

#   # This only supports org policies of list types
#   list_policy_override_map = {}

#   # This only supports org policies of boolean types
#   boolean_policy_override_map = {
#     "storage.publicAccessPrevention" = [
#       {
#         policy_root    = "project"
#         policy_root_id = "prj-bootstrap"
#       },
#       {
#         policy_root    = "project"
#         policy_root_id = "prj-bootstrap"
#       }
#     ]
#     "compute.managed.vmCanIpForward" = [
#       {
#         policy_root    = "project"
#         policy_root_id = "prj-bootstrap"
#       },
#       {
#         policy_root    = "project"
#         policy_root_id = "prj-bootstrap"
#       }
#     ]
#     "compute.managed.disableSerialPortAccess" = [
#       {
#         policy_root    = "project"
#         policy_root_id = "prj-bootstrap"
#       }
#     ]
#     "compute.managed.requireOsLogin" = [
#       {
#         policy_root    = "project"
#         policy_root_id = "prj-bootstrap"
#       }
#     ]
#   }

#   # These two structures should not be used directly.
#   # Their purpose is to transform the front facing map above to pass it to a module conveniently.
#   # Please only use the map above to add more exceptions.
#   flattened_boolean_policy_overrides = flatten([
#     for constraint, overrides in local.boolean_policy_override_map : [
#       for override in overrides : {
#         constraint     = constraint
#         policy_root    = override.policy_root
#         policy_root_id = override.policy_root_id
#         unique_key     = "${constraint}:${override.policy_root_id}"
#       }
#     ]
#   ])
#   final_boolean_policy_override_module_map = {
#     for item in local.flattened_boolean_policy_overrides : item.unique_key => item
#   }
# }

# /**************************************************
# Boolean Policy Exceptions
# **************************************************/
# module "boolean_policy_override" {
#   source = "./../../modules/org-policy-v2"

#   for_each       = local.final_boolean_policy_override_module_map
#   policy_root    = each.value.policy_root
#   policy_root_id = each.value.policy_root_id
#   constraint     = each.value.constraint

#   rules = [
#     {
#       enforcement = false
#     }
#   ]
#   policy_type = "boolean"
# }

# # TODO: add support for list policies override when needed


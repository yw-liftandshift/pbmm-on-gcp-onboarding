output "prod_network" {
  value = module.net-host-prj
}

output "access_context_manager_parent_id" {
  value = module.access-context-manager.parent_id
}

output "folders_map_2_levels" {
  value = module.core-folders.folders_map_2_levels
}
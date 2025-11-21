
module "projects" {

  for_each = local.projects

  source   = "../../modules/project-template"

  project_name = each.value.project_name
  admin_group  = each.value.admin_group
  editor_group = each.value.editor_group

  identity_domain   = local.identity_domain 

  metadata = each.value.metadata

  billing_account   = local.billing_account
  folder            = each.value.metadata.data_classification == "unclass" ? google_folder.folder_unclass.name : google_assured_workloads_workload.folder_pb.resources[0].resource_id
  project_prefix    = local.project_prefix


}

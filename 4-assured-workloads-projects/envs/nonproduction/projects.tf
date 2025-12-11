/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
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

  regions = local.regions

}

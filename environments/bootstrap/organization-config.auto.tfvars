/**
 * Copyright 2022 Google LLC
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



organization_config = {
  org_id          = "946862951350" # REQUIRED EDIT Numeric portion only '#############'"
  default_region  = "northamerica-northeast1" # REQUIRED EDIT Cloudbuild Region - default to na-ne1 or 2
  department_code = "Lz" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
  owner           = "Qc" # REQUIRED EDIT Used in naming standard
  environment     = "S" # REQUIRED EDIT S-Sandbox P-Production Q-Quality D-development
  location        = "northamerica-northeast1" # REQUIRED EDIT Location used for resources. Currently northamerica-northeast1 is available
  labels          = {} # REQUIRED EDIT Object used for resource labels
  # switch out root_node depending on whether you are running directly off the organization or a folder
  root_node       = "organizations/946862951350" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
  #root_node       = "folders/" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
  
  contacts = {
    "gcp-organization-admins@gcp.mcn.gouv.qc.ca" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
  }
  billing_account = "01A591-8B15FB-F4CD0B" # REQUIRED EDIT Format of ######-######-######
}


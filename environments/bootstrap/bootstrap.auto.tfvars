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



# This bootstrap script is meant to be run by one elevated user, in one sitting, with the permanent naming convention to be used. 
# CAVEATS - The reason for this is: 
# Permissions for that user are temporary, changing users before the automation takes over operations locks other users out of this process
# Accomplishing this is one sitting allows all users to contribute to repairing any issues in the environment by contributing code
# Project_Ids are globally consistent across all of Google Cloud Platform, projects take 7 days to delete and wont release that unique name until fully deleted. 
#

bootstrap = {
  userDefinedString           = "qcb" # REQUIRED EDIT Appended to project name/id ##needs to be lower case and min. 3 characters
  additionalUserDefinedString = "" # OPTIONAL EDIT Additional appended string
  billingAccount              = "01A591-8B15FB-F4CD0B" # REQUIRED EDIT Billing Account in the format of ######-######-######
  # switch out root_node depending on whether you are running directly off the organization or a folder
  parent                      = "organizations/946862951350" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
  #parent                      = "folders/" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
  terraformDeploymentAccount  = "tf-deploy" # REQUIRED EDIT Name of a service account to be created (alphanumeric before the at sign) used to deploy the terraform code
  bootstrapEmail              = "user:uday.kakkar@yoppworks.com" # REQUIRED EDIT In the form of 'user:user@email.com
  region                      = "northamerica-northeast1" # REQUIRED EDIT Region name. northamerica-northeast1
  cloud_source_repo_name      = "pbmm-lz-qc" # REQUIRED EDIT CSR used as a mirror for code
  projectServices = [
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "sourcerepo.googleapis.com",
    "appengine.googleapis.com"
  ]
  tfstate_buckets = {
    common = {
      name = "bootstrapcommonbucketqc" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
      labels = {
      }
      storage_class = "STANDARD"
      force_destroy = true
    },
    nonprod = {
      name = "bootstrapnonprbucketqc" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
      labels = {
      }
      force_destroy = true
      storage_class = "STANDARD"
    },
    prod = {
      name = "bootstrapprodbucketqc" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
      labels = {
      }
      force_destroy = true
      storage_class = "STANDARD"
    }
  }
}
# Cloud Build
cloud_build_admins = [
  "group:gcp-organization-admins@gcp.mcn.gouv.qc.ca", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
]
group_build_viewers = [
  "group:gcp-organization-view@gcp.mcn.gouv.qc.ca", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
]

#cloud_build_user_defined_string = ""



cloud_build_config = { # OPTIONAL EDIT Defines the triggers for the different environments in cloud build
  landing-zone-bootstrap = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/bootstrap",
    included_files = [
      "environments/bootstrap/**",
      "modules/**"
    ],
    ignored_files        = [],
    pull_trigger_enabled = false,
    pull_gcbrun_enabled  = false,
    push_trigger_enabled = true
  }
  landing-zone-common = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/common",
    included_files = [
      "environments/common/**",
      "modules/**"
    ],
    ignored_files        = [],
    pull_trigger_enabled = false,
    pull_gcbrun_enabled  = false,
    push_trigger_enabled = true
  }
  landing-zone-nonprod = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/nonprod",
    included_files = [
      "environments/nonprod/**",
      "modules/**"
    ],
    ignored_files        = [],
    pull_trigger_enabled = false,
    pull_gcbrun_enabled  = false,
    push_trigger_enabled = true
  }
  landing-zone-prod = {
    gcp_folder_suffix = "Automation",
    workstream_path   = "environments/prod",
    included_files = [
      "environments/prod/**",
      "modules/**"
    ],
    ignored_files        = [],
    pull_trigger_enabled = false,
    pull_gcbrun_enabled  = false,
    push_trigger_enabled = true
  }
}

/*
sa_impersonation_admin = ""


sa_impersonation_grants= [
    {
      member  = "group:name@name.canada.ca"
      project = module.project.project_id
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    }
]


sa_create_assign = [
    {
      account_id   = "test-account"
      display_name = "test1 display"
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    },
    {
      account_id   = "another-test"
      display_name = "Another Test"
      roles = [
        "roles/viewer",
        "roles/editor",
      ]
    }
  ]

*/

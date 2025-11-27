/**
 * Copyright 2021 Google LLC
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

locals {
  env = "nonproduction"

  org_id = data.terraform_remote_state.bootstrap.outputs.common_config.org_id

  default_region   = data.terraform_remote_state.bootstrap.outputs.common_config.default_region
  default_region_1 = "${data.terraform_remote_state.bootstrap.outputs.common_config.default_region}-a"
  default_region_2 = "${data.terraform_remote_state.bootstrap.outputs.common_config.default_region}-b"

  base_host_project_id = data.terraform_remote_state.networks.outputs.base_host_project_id
  base_network_name    = data.terraform_remote_state.networks.outputs.base_network_name

  restricted_host_project_id = data.terraform_remote_state.networks.outputs.restricted_host_project_id
  restricted_network_name    = data.terraform_remote_state.networks.outputs.restricted_network_name

  firewall_endpoint_1    = data.terraform_remote_state.cloud_firewall_shared.outputs.firewall_endpoint_1
  firewall_endpoint_2    = data.terraform_remote_state.cloud_firewall_shared.outputs.firewall_endpoint_2
  security_profile_group = data.terraform_remote_state.cloud_firewall_shared.outputs.security_profile_group

  parent_folder = data.terraform_remote_state.environments_env.outputs.env_folder
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}


data "terraform_remote_state" "networks" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/${local.env}"
  }
}

data "terraform_remote_state" "cloud_firewall_shared" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/cloud-firewall/shared"
  }
}

data "terraform_remote_state" "environments_env" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/environments/${local.env}"
  }
}


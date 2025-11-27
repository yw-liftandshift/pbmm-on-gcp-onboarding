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
 
 locals {

  env                = "nonproduction"
  folder_name        = "group-pb-1"
  project_prefix     = "group1"

  parent_folder_name = data.terraform_remote_state.env.outputs.env_folder

  region = data.terraform_remote_state.bootstrap.outputs.common_config.default_region
  organization = data.terraform_remote_state.bootstrap.outputs.common_config.org_id

  directory_customer_id = data.google_organization.org.directory_customer_id
  identity_domain      = data.google_organization.org.domain

  projects = jsondecode(file("projects.json"))
  groups  = jsondecode(file("groups.json"))

  billing_account = data.terraform_remote_state.bootstrap.outputs.common_config.billing_account

  regions = [
    data.terraform_remote_state.bootstrap.outputs.common_config.default_region, #northamerica-northeast1
    "northamerica-northeast2"
  ]

}

data "google_organization" "org" {
  organization = local.organization
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}

data "terraform_remote_state" "env" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/environments/${local.env}"
  }
}

data "terraform_remote_state" "org" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/org/state"
  }
}

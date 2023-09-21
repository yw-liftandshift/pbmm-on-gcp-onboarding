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

module "project_name" {
  source = "../naming-standard//modules/gcp/project"

  department_code                = var.department_code
  environment                    = var.environment
  location                       = var.location
  owner                          = var.owner
  user_defined_string            = var.user_defined_string
  additional_user_defined_string = var.additional_user_defined_string
}

module "state_bucket_names" {
  source = "../naming-standard//modules/gcp/storage"

  for_each        = var.tfstate_buckets
  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = lower(each.value.name)
}

module "bucket_log_bucket_name" {
  source = "../naming-standard//modules/gcp/storage"

  department_code = var.department_code
  environment     = var.environment
  location        = var.location

  user_defined_string = "bucketusagestoragelogs"
}

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


resource "google_service_account" "service_account" {
  project      = var.project
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_project_iam_member" "role_assignment" {
  for_each = toset(var.roles)

  role    = each.value
  project = var.project
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
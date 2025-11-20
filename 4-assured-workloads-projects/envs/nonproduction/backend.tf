terraform {
  backend "gcs" {
    bucket = "UPDATE_PROJECTS_BACKEND"
    prefix = "terraform/projects/business-unit/development"
  }
}

provider "google" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google-beta" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
}
provider "google-beta" {
  access_token = data.google_service_account_access_token.default.access_token

}
provider "null" {

}
data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = "tf-deploy@lzse-qc-qcb.iam.gserviceaccount.com"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1800s"
}


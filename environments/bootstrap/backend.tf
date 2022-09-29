terraform {
  backend "gcs" {
    bucket = "lzsebootstrapcommonbucketqc"
    prefix = "environments/bootstrap"
  }
}

terraform {
  backend "gcs" {
    bucket = "lzsebootstrapcommonbucketqc"
    prefix = "environments/common"
  }
}
data "terraform_remote_state" "bootstrap" {
    backend = "gcs"
    config = {
      bucket = "lzsebootstrapcommonbucketqc"
      prefix = "environments/bootstrap"
    }  
}
data "terraform_remote_state" "common" {
    backend = "gcs"
    config = {
      bucket = "lzsebootstrapcommonbucketqc"
      prefix = "environments/common"
    }  
}
provider "google" {
  project = var.project_id
  region  = var.gcp_region
}


/*
terraform {
  backend "gcs" {
    bucket = "<your tf state bucket name>"
    prefix = "terraform/state"
  }
}
*/


//build the tf_state bucket
resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_storage_bucket" "tf_state_bucket" {
  name          = "bkt-tfstate-${random_id.instance_id.hex}"
  force_destroy = false
  location      = var.gcp_region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }

}
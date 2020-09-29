terraform {
  backend "remote" {
    organization = "davilag-cloud-infra"

    workspaces {
      name = "gcp-cloud-infra"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = file(var.credentials)
  project     = var.project_id
  region      = var.region
}

data "google_client_config" "current" {}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.current.access_token
    client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}
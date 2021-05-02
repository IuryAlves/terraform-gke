terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "3.66.1"
    }
  }
}   

provider "google-beta" {

  credentials = file("google-creds.json")
  project = var.project_id
  region = var.region
  zone = var.zone
}

provider "google" {

  credentials = file("google-creds.json")
  project = var.project_id
  region = var.region
  zone = var.zone
}

module "service_accounts" {
  source = "./modules/service_accounts"
  project = var.project_id
  service_account_name = var.service_account_name
}


resource "google_container_cluster" "test_cluster" {
  provider = google-beta
  name = var.cluster_name
  location = var.region
  remove_default_node_pool = true
  initial_node_count = 1
  
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    config_connector_config {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "nodepool_1" {
  provider = google-beta
  name = var.nodepool_name
  location = var.region
  cluster = google_container_cluster.test_cluster.name
  node_count = 1
  
  node_config {
    machine_type = var.machine_type
    service_account = "${var.service_account_name}@${var.project_id}.iam.gserviceaccount.com" 

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

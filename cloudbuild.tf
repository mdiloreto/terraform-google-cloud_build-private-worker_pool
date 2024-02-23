terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "> 3.5"
    }
  }
}
######## Enable APIs

resource "google_project_service" "service_networking_api" {
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false

}

resource "google_project_service" "cloud_build_api" {
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = false

}

resource "google_project_service" "iam_api" {
  service = "iam.googleapis.com"
  disable_on_destroy = false
  
}
# Get CLoud Build Built-in Service Account
resource "google_project_service_identity" "build_account" {
  provider = google-beta
  service = "cloudbuild.googleapis.com"
  depends_on = [ google_project_service.cloud_build_api ]

}


############ Workper Pool network enviroment configuration & Private pool creation

resource "google_compute_global_address" "worker_range" {
  name          = "${var.workerpool_name}-alloc-range"
  purpose       = var.purpose
  address_type  = var.address_type
  prefix_length = var.prefix_length
  network       = var.network
  address       = var.alloc_range_address
}

resource "google_service_networking_connection" "worker_pool_conn" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.worker_range.name]
  
  depends_on              = [google_project_service.service_networking_api]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering = google_service_networking_connection.worker_pool_conn.peering
  network = var.vpc_network

  import_custom_routes = false
  export_custom_routes = true
}

resource "google_cloudbuild_worker_pool" "pool" {
  name = var.workerpool_name
  location = var.cb_region
  worker_config {
    disk_size_gb = var.wp_disk_size
    machine_type = var.marchine_type
    no_external_ip = var.no_external_ip
  }
  network_config {
    peered_network = var.network
    peered_network_ip_range = "${var.alloc_range_address}/${var.prefix_length}"
  }
  depends_on = [google_service_networking_connection.worker_pool_conn]
}

############ Cloud Build Trigger creation 
resource "google_cloudbuild_trigger" "build-trigger" {
  name     = var.cb_trigger_name
  filename = var.cb_filename
  location = var.cb_region

  trigger_template {
    branch_name = ".*"
    repo_name   = var.cb_repo_name
  }

  substitutions = var.substitutions
}

resource "google_cloudbuild_trigger" "manual-rollback-trigger" {
  name        = var.cb_rollback_trigger_name
  description = "A manual trigger for Cloud Build rollback procedure"
  filename    = var.cb_filename
  location    = var.cb_region

  trigger_template {
    branch_name = ".*"
    repo_name   = var.cb_rollback_repo_name
  }

  approval_config {
    approval_required = true
  }

  substitutions = var.substitutions
}

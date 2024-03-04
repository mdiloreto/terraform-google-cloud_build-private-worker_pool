######## Enable APIs

resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "serviceusage" {
  project            = var.project_id
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}


resource "google_project_service" "cloudresourcemanager" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

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
  name          = var.workerpool_range_name
  purpose       = var.purpose
  address_type  = var.address_type
  prefix_length = var.allocation_prefix_length
  network       = var.network
  address       = var.alloc_range_address
}

resource "google_service_networking_connection" "worker_pool_conn" {
  provider                = google-beta
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = var.reserved_peering_ranges

  depends_on              = [google_project_service.service_networking_api]

}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  project = var.project_id
  peering = google_service_networking_connection.worker_pool_conn.peering
  network = var.network
  
  import_custom_routes = var.peering_import_custom_routes
  export_custom_routes = var.peering_export_custom_routes
  
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
    peered_network = var.network_id
    peered_network_ip_range = "${var.alloc_range_address}/${var.cb_prefix_length}"
  }
  depends_on = [google_service_networking_connection.worker_pool_conn]
}

resource "google_project_iam_member" "worker_pool_user" {
  project = var.project_id
  role    = "roles/cloudbuild.workerPoolUser"
  member  = "serviceAccount:${google_project_service_identity.build_account.email}"
}


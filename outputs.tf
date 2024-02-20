output "cloud_build_service_account_name" {
  description = "The Google-managed service account for Cloud Build"
  value       = google_project_service_identity.build_account.email
}

output "worker_range_address_name" {
  description = "The name of the global address for the worker range"
  value       = google_compute_global_address.worker_range.name
}

output "cloudbuild_worker_pool_name" {
  description = "The name of the Cloud Build worker pool"
  value       = google_cloudbuild_worker_pool.pool.name
}

output "cloudbuild_trigger_name" {
  description = "The name of the Cloud Build trigger"
  value       = google_cloudbuild_trigger.build-trigger.name
}

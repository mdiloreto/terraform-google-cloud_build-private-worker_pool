# Terraform Module for Configuring a Cloud Build Private Worker Pool

## Overview

This Terraform module facilitates the creation and configuration of a private worker pool for Cloud Build in Google Cloud Platform (GCP). It enables you to execute build jobs in an isolated environment, enhancing security and compliance for sensitive projects. This module also allows for the customization of network configurations, including the VPC and subnetwork settings.

## Prerequisites

- Terraform v0.14 or newer.
- A GCP account with permissions to create and manage Cloud Build and VPC resources.
- (Optional) A pre-existing VPC and subnetwork if you choose not to create them as part of this module's deployment.

## Provider Configuration

To use this module, ensure that you have configured the required providers in your Terraform configuration. The module requires the use of both the `google` and `google-beta` providers, with a specific emphasis on using version 4.x for the `google-beta` provider. This version is essential for accessing certain beta features that may be utilized within the module.

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "> 3.5"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      // It is crucial to use version 4.x of the google-beta provider
      version = "~> 4.9"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
```

## Module Inputs

- `project_id`: The ID of the GCP project.
- `cb_region`: The region for the Cloud Build private worker pool.
- `network`: The name of the VPC network.
- `network_id`: The full VPC network self link.
- `workerpool_name`: The name for the Cloud Build private worker pool.
- `alloc_range_address`: The starting address for the IP range of the worker pool.
- `allocation_prefix_length`: The prefix length for the IP range of the worker pool.
- `cb_prefix_length`: The prefix length for the Cloud Build IP range within the worker pool.
- `reserved_peering_ranges`: A list of reserved peering ranges for the network.
- `workerpool_range_name`: The name for the worker pool IP range.
- `peering_export_custom_routes`: Boolean to enable/disable export of custom routes to the peering network.
- `peering_import_custom_routes`: Boolean to enable/disable import of custom routes from the peering network.

## Usage Example

Below is an example of how you can use this module to configure a Cloud Build private worker pool. Note that the creation of the VPC and subnetwork is optional and dependent on your specific infrastructure setup.

```hcl
/*
resource "google_compute_network" "vpc_network" {
  project = var.project_id
  name = var.network
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_network" {
  project       = var.project_id
  name          = var.subnet
  ip_cidr_range = var.subnet_ip_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
*/

module "cloud_build_private_worker_pool" {
  source = "./cloud-build"
  project_id                = "your-project-id"
  cb_region                 = "us-central1"
  network                   = "your-vpc-network"
  network_id                = "projects/your-project-id/global/networks/your-vpc-network"
  workerpool_name           = "your-worker-pool-name"
  alloc_range_address       = "172.16.0.0"
  allocation_prefix_length  = "24"
  cb_prefix_length          = "26"
  reserved_peering_ranges   = ["cloud-build-allocation", "another-reserved-range"]
  workerpool_range_name     = "cloud-build-allocation"
  peering_export_custom_routes = true
  peering_import_custom_routes = false
}

```

Ensure to replace placeholder values with actual data relevant to your GCP setup.

## Contributing
Contributions to this module are welcome! Please refer to the contributing guidelines for more details.




variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "workerpool_name" {
  description = "The name of the worker pool"
  type        = string
}

variable "network" {
  description = "The VPC network to use"
  type        = string
}

variable "network_id" {
  description = "The VPC network ID to use"  
}


variable "cb_region" {
  description = "The location for the worker pool "
  type        = string
}

variable "marchine_type" {
  description = "The machine type for the worker pool"
  default = "e2-medium"
  type        = string
}

variable "wp_disk_size" {
  default = "100"
  type = number
}

variable "no_external_ip" {
  description = "Setting for the Worker Pool to have an external IP. No assigned by default"
  type = bool
  default = true
}

variable "address_type" {
  type = string
  default = "INTERNAL"
}
variable "purpose" {
  type = string
  default = "VPC_PEERING"
}

variable "allocation_prefix_length" {
  description = "Prefix length to be determined in the in the VPC Private Service IP Allocation"
  default = "16"
}

variable "cb_prefix_length" {
  description = "The prefix length used for Cloud Build within the worker pool."
  default = "24"
}

variable "alloc_range_address" {
    description = "IP Address Range to be determined in the in the VPC Private Service IP Allocation"

}

variable "workerpool_range_name" {
  description = "IP Range for the Private Access Connection for the Cloud Build reservation"
}

variable "reserved_peering_ranges" {
  description = "Reserved IP Allocated ranges for the NewtworkingServicesConnection API. This must include the workerpool_range name and other ranges that already exists in the existing connection"
  type = list(string)
}

variable "peering_import_custom_routes" {
  type = bool
  description = "Set this value True if you want to import the custom routes from the VPC to the Service Provider Network"
}

variable "peering_export_custom_routes" {
  type = bool
  description = "Set this value True if you want to export the custom routes from the VPC to the Service Provider Network"
}

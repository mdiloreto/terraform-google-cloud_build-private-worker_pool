
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

variable "cb_region" {
  description = "The location for the worker pool and build trigger"
  type        = string
}

variable "marchine_type" {
  description = "The machine type for the worker pool"
  default = "e2-medium"
  type        = string
}

variable "cb_trigger_name" {
  description = "The name of the Cloud Build trigger"
  type        = string
}

variable "cb_filename" {
  description = "The filename for the Cloud Build trigger"
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

variable "prefix_length" {
  default = "16"
}
variable "cb_ref" {
  default = "refs/heads/main"
}

variable "cb_repo_name" {
  type = string
}

variable "cb_repo_type" {
  type = string
}

variable "vpc_network" {}
variable "alloc_range_address" {}
variable "cb_rollback_trigger_name" {}
variable "cb_rollback_repo_name" {}

variable "substitutions" {
  description = "A map of substitutions to be used in the build"
  type        = map(string)
}
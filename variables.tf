variable "project_id" {
    type = string
    description = "ID of target Google Cloud project"
    default = ""
    nullable = false
}

variable "project_region" {
    type = string
    description = "Default region to use with target Google Cloud project"
    default = "us-central1"
}

variable "compute_instance_image_name" {
    type = string
    description = "Name of the GCP image to use for test compute instance"
    default = "debian-cloud/debian-12"  # Debian 12 Bookworm
}

variable "compute_zone" {
    type = string
    description = "GCP zone to use for Compute VMs"
    default = "us-central1-a"
}

variable "compute_network" {
    type = string
    description = "GCP network to use for Compute VMs"
    default = "default"
}
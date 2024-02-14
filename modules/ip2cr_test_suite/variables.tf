variable "project_region" {
    type = string
    description = "Default region to use with target Google Cloud project"
}

variable "compute_zone" {
    type = string
    description = "GCP zone to use for Compute VMs"
}

variable "compute_instance_image_name" {
    type = string
    description = "Name of the GCP image to use for test compute instance"
}

variable "compute_network" {
    type = string
    description = "GCP network to use for Compute VMs"
}
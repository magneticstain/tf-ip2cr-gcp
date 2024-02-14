terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.16.0"
    }
  }

  required_version = ">= 1.2.0"

  backend "gcs" {}
}

provider "google" {
  project = var.project_id
  region  = var.project_region
}

module "ip2cr-test-suite" {
    source = "./modules/ip2cr_test_suite"
    project_region = var.project_region
    compute_instance_image_name = var.compute_instance_image_name
    compute_zone = var.compute_zone
    compute_network = var.compute_network
}

output "ip2cr-testing-metadata" {
  value = [
    module.ip2cr-test-suite.ip2cr-compute-metadata,
    module.ip2cr-test-suite.ip2cr-gclb-metadata,
    module.ip2cr-test-suite.ip2cr-cloudsql-metadata
  ]
}

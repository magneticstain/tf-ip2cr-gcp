# Generate all resources supported by ip2cr

# Compute
resource "google_service_account" "ip2cr-test-compute" {
  account_id   = "ip2cr-test-compute"
  display_name = "Custom SA for VM Instance Used With IP2CR Testing"
}

resource "google_compute_instance" "ip2cr-test" {
  name = "ip2cr-test-instance"
  machine_type = "e2-micro"
  zone = var.compute_zone

  boot_disk {
    initialize_params {
      image = var.compute_instance_image_name
      size  = 10
    }
  }

  network_interface {
    network = var.compute_network

    access_config {}
  }

  service_account {
    email  = google_service_account.ip2cr-test-compute.email
    scopes = ["cloud-platform"]
  }
}

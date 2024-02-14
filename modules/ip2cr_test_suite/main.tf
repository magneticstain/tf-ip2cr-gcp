# Generate all resources supported by ip2cr

## GCLB
resource "google_service_account" "ip2cr-test-gclb" {
  account_id   = "ip2cr-test-gclb"
  display_name = "Custom SA for VM Instance Used With IP2CR Testing"
}

### Instances
resource "google_compute_instance_template" "ip2cr-test-compute-template" {
  name            = "ip2cr-test-compute-template"
  machine_type    = "e2-micro"
  region          = var.project_region

  disk {
    auto_delete   = true
    boot          = true
    source_image  = var.compute_instance_image_name
  }

  network_interface {
    network = var.compute_network

    access_config {}
  }

  service_account {
    email   = google_service_account.ip2cr-test-gclb.email
    scopes  = ["cloud-platform"]
  }

  tags = ["allow-http-public"]
}

resource "google_compute_instance_group_manager" "ip2cr-test-instance-grp" {
  name  = "ip2cr-test-instance-grp"
  zone  = var.compute_zone

  base_instance_name = "ip2cr-lb-vm"
  target_size        = 2

  named_port {
    name  = "http"
    port  = 80
  }

  version {
    instance_template = google_compute_instance_template.ip2cr-test-compute-template.id
    name              = "primary"
  }
}

### Networking
resource "google_compute_health_check" "ip2cr-test-gclb-health-check" {
  name                = "ip2cr-test-gclb-http-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port               = 80
    request_path       = "/"
  }
}

resource "google_compute_backend_service" "ip2cr-test-backend-svc" {
  name          = "ip2cr-test-backend-svc"
  health_checks = [ google_compute_health_check.ip2cr-test-gclb-health-check.id ]
  port_name     = "http"
  protocol      = "HTTP"
  timeout_sec   = 30

  backend {
    group = google_compute_instance_group_manager.ip2cr-test-instance-grp.instance_group
  }
}

resource "google_compute_url_map" "ip2cr-test-url-map" {
  name            = "ip2cr-test-url-map-http"
  default_service = google_compute_backend_service.ip2cr-test-backend-svc.id
}

resource "google_compute_target_http_proxy" "ip2cr-test-target-http-proxy" {
  name    = "ip2cr-test-target-http-proxy"
  url_map = google_compute_url_map.ip2cr-test-url-map.id
}

resource "google_compute_global_address" "ip2cr-test-global-ipv4-address" {
  name       = "ip2cr-test-lb-ipv4-1"
  ip_version = "IPV4"
}
resource "google_compute_global_forwarding_rule" "ip2cr-test-forwarding-rule" {
  name        = "ip2cr-test-forwarding-rule"
  target      = google_compute_target_http_proxy.ip2cr-test-target-http-proxy.id
  port_range  = 80
  ip_address = google_compute_global_address.ip2cr-test-global-ipv4-address.id
}

resource "google_compute_global_address" "ip2cr-test-global-ipv6-address" {
  name       = "ip2cr-test-lb-ipv6-1"
  ip_version = "IPV6"
}
resource "google_compute_global_forwarding_rule" "ip2cr-test-forwarding-rule-ipv6" {
  name        = "ip2cr-test-forwarding-rule-ipv6"
  target      = google_compute_target_http_proxy.ip2cr-test-target-http-proxy.id
  port_range  = 80
  ip_address = google_compute_global_address.ip2cr-test-global-ipv6-address.id
}

resource "google_compute_firewall" "ip2cr-test-firewall" {
  name          = "ip2cr-test-firewall"
  network       = "default"
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http-public"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

output "ip2cr-gclb-metadata" {
  value = [
    google_compute_instance_group_manager.ip2cr-test-instance-grp.instance_group,
    google_compute_global_address.ip2cr-test-global-ipv4-address.address,
    google_compute_global_address.ip2cr-test-global-ipv6-address.address,
  ]
}

## Compute
resource "google_service_account" "ip2cr-test-compute" {
  account_id   = "ip2cr-test-compute"
  display_name = "Custom SA for VM Instance Used With IP2CR Testing"
}

resource "google_compute_instance" "ip2cr-test" {
  name          = "ip2cr-test-instance"
  machine_type  = "e2-micro"
  zone          = var.compute_zone

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

output "ip2cr-compute-metadata" {
  value = [
    google_compute_instance.ip2cr-test.id,
    google_compute_instance.ip2cr-test.instance_id,
    google_compute_instance.ip2cr-test.network_interface.0.access_config.0.nat_ip
  ]
}

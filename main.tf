terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.16.0"
    }
  }

  backend "gcs" {}
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_project_region
}

# module "ip2cr-test-suite" {
#     source = "./modules/ip2cr_test_suite"
#     ami_id = var.ami_id
#     key_pair_name = var.key_pair_name
#     subnets = var.subnets
#     vpc = var.vpc
# }

# output "ip2cr-testing-metadata" {
#   value = [
#     module.ip2cr-test-suite.ip2cr-ec2-metadata,
#     module.ip2cr-test-suite.ip2cr-cf-distro-metadata,
#     module.ip2cr-test-suite.ip2cr-testing-alb-metadata,
#     module.ip2cr-test-suite.ip2cr-testing-nlb-metadata,
#     module.ip2cr-test-suite.ip2cr-testing-elb-metadata
#   ]
# }

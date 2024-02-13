variable "tf_backend_bucket_name" {
    type = string
    description = "GCP Cloud Storage bucket used for backend configs"
    default = ""
    nullable = false
}

variable "gcp_project_id" {
    type = string
    description = "ID of target Google Cloud project"
    default = ""
    nullable = false
}

variable "gcp_project_region" {
    type = string
    description = "Default region to use with target Google Cloud project"
    default = "us-central1"
    nullable = false
}
# tf-ip2cr-gcp

Terraform plans for generating ephemeral test resources for testing ip2cr in GCP.

## Summary

Currently, this set of terraform plans:

1. Creates a GCP Compute instance
1. Generates a load balancer that fronts two other instances
1. Starts a CloudSQL instance

This should provide several vectors for testing IP2CR.

## Usage

### Configure GCP Application Default Credentials

If needed, configure local [application default credentials](https://cloud.google.com/docs/authentication/provide-credentials-adc) for gcloud:

```bash
gcloud auth application-default login
```

### Bootstrap the Prerequisite Resources

The plans use Google Cloud Storage as a backend. A standalone Terraform plan is included to generate the prerequisite infrastructure to support this:

```bash
cd ./utils/generate_backend/
export GOOGLE_PROJECT="<GCP_PROJECT_ID>"
terraform init && terraform apply
```

After Terraform completes its run, it should include the Cloud Storage bucket name in the output; keep this handy as we will need it for the next step.

Example:

```bash
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

tf-gcs-bucket-metadata = [
  "tf-ip2cr-gcp-ce925bf29c4ee1b4-bucket-tfstate",
]
```

#### Generate Backend Vars

Generate a `backend.tfvars` file in the project root and fill in the variables as appropriate.

```hcl
bucket = "<TF_GCS_BUCKET_NAME>"
prefix = "terraform/state"
```

Example:

```hcl
bucket = "tf-ip2cr-gcp-ce925bf29c4ee1b4-bucket-tfstate"
prefix = "terraform/state"
```

### Set TF Vars

Generate a `terraform.tfvars` file and fill in the variables as appropriate.

```hcl
gcp_project_id = "<GCP_PROJECT_ID>"
gcp_project_region = "<GCP_PROJECT_REGION>"
```

Example:

```hcl
gcp_project_id = "ip-2-cloudresource"
gcp_project_region = "us-central1"
```

### Plan and Apply Plans

A Make file has been included to make running these plans easier. There is no need to initialize the environment, or any other prerequesite work, prior to running these commands.

#### Plan

```bash
make plan
```

#### Apply

```bash
make apply
```

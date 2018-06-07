# Slack Event Publisher

Send Slack events to Google Cloud Pub/Sub using Cloud Functions.

## Quickstart

Download the credentials file from Google Cloud for your service account and rename to `client_secret.json`.

Create a `terraform.tfvars` file with your access keys & custom configuration:


```terraform
# terraform.tfvars

# Cloud Storage bucket for storing function source
bucket_name = "<cloud-storage-bucket>"

# Cloud Project ID
project = "<cloud-project-123456>"

# Slack verification token
verification_token = "<verification-token>"
```

Then, create a `terraform.tf` file with the following contents (filling in the module version):

```terraform
# terraform.tf

provider "google" {
  credentials = "${file("${var.client_secret}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.13"
}

module "slack_event_publisher" {
  source             = "amancevice/slack-event-publisher/google"
  version            = "<module-version>"
  bucket_name        = "${var.bucket_name}"
  client_secret      = "${var.client_secret}"
  project            = "${var.project}"
  verification_token = "${var.verification_token}"
  event_types        = [
    "channel_rename",
    "group_rename",
    "member_joined_channel",
    "member_left_channel"
  ]
}

variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "client_secret" {
  description = "Google Cloud client secret JSON filepath."
  default     = "client_secret.json"
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

variable "region" {
  description = "The region to operate under, if not specified by a given resource."
  default     = "us-central1"
}

variable "verification_token" {
  description = "Slack verification token."
}

output "pubsub_topics" {
  description = "Pub/Sub topics created."
  value       = "${module.slack_event_publisher.pubsub_topics}"
}

output "request_url" {
  description = "Slack event Request URL."
  value       = "${module.slack_event_publisher.request_url}"
}
```

In a terminal window, initialize the state:

```bash
terraform init
```

Then review & apply the changes

```bash
terraform apply
```

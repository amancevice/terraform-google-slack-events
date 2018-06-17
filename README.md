# Slack Event Listener/Publisher

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

Then, create a `terraform.tf` file with the following contents:

```terraform
# terraform.tf

provider "google" {
  credentials = "${file("client_secret.json")}"
  project     = "${var.project}"
  region      = "us-central1"
}

module "slack_events" {
  source             = "amancevice/slack-events/google"
  bucket_name        = "${var.bucket_name}"
  client_secret      = "${file("client_secret.json")}"
  verification_token = "${var.verification_token}"
  event_types        = [
    # Slack event types to subscribe to
    # https://api.slack.com/events
  ]
}

variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "project" {
  description = "The ID of the project to apply any resources to."
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

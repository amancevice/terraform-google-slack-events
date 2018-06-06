provider "google" {
  credentials = "${file("client_secret.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.13"
}

module "slack_event_publisher" {
  source             = "amancevice/slack-event-publisher/google"
  version            = "0.0.3"
  bucket_name        = "${var.bucket_name}"
  project            = "${var.project}"
  service_account    = "${var.service_account}"
  verification_token = "${var.verification_token}"
}

variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

variable "service_account" {
  description = "An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com."
}

variable "verification_token" {
  description = "Slack verification token."
}

variable "region" {
  description = "Cloud region name."
  default     = "us-central1"
}

output "pubsub_topic" {
  value = "${module.slack_event_publisher.pubsub_topic}"
}

output "event_publisher_url" {
  value = "${module.slack_event_publisher.event_publisher_url}"
}

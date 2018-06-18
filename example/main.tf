provider "google" {
  credentials = "${file("${var.google_client_secret}")}"
  project     = "${var.google_project}"
  region      = "${var.google_region}"
  version     = "~> 1.14"
}

resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

module "slack_events" {
  source             = "amancevice/slack-events/google"
  bucket_name        = "${google_storage_bucket.bucket.name}"
  event_types        = ["${var.slack_events_event_types}"]
  function_name      = "${var.slack_events_function_name}"
  memory             = "${var.slack_events_memory}"
  timeout            = "${var.slack_events_timeout}"
  verification_token = "${var.slack_events_verification_token}"
}

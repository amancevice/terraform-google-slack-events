provider "archive" {
  version = "~> 1.0"
}

provider "template" {
  version = "~> 1.0"
}

locals {
  version = "0.0.3"
}

// Config template
data "template_file" "config" {
  template = "${file("${path.module}/src/config.tpl")}"

  vars {
    pubsub_topic       = "${var.pubsub_topic}"
    project            = "${var.project}"
    verification_token = "${var.verification_token}"
  }
}

// Event Publisher archive
data "archive_file" "archive" {
  type        = "zip"
  output_path = "${path.module}/dist/event-publisher-${local.version}.zip"

  source {
    content  = "${file("${path.module}/src/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${file("${path.module}/package.json")}"
    filename = "package.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${var.client_secret}")}"
    filename = "client_secret.json"
  }
}

// Cloud Storage Bucket for storing Cloud Function archives
resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

// Add service acct as writer to Cloud Storage Bucket
resource "google_storage_bucket_iam_member" "member" {
  bucket = "${google_storage_bucket.bucket.name}"
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.service_account}"
}

// Event Publisher Cloud Storage archive
resource "google_storage_bucket_object" "archive" {
  bucket = "${google_storage_bucket.bucket.name}"
  name   = "${var.bucket_prefix}${var.function_name}-${local.version}.zip"
  source = "${data.archive_file.archive.output_path}"
}

// Pub/Sub Topic for processing events
resource "google_pubsub_topic" "topic" {
  name = "${var.pubsub_topic}"
}

// Event Publisher Cloud Function
resource "google_cloudfunctions_function" "function" {
  name                  = "${var.function_name}"
  description           = "Slack event publisher"
  available_memory_mb   = "${var.memory}"
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  trigger_http          = true
  timeout               = "${var.timeout}"
  entry_point           = "publishEvent"

  labels {
    deployment-tool = "terraform"
  }
}

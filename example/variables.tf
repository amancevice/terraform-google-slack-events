// Google Cloud
variable "google_client_secret" {
  description = "Google Cloud client secret JSON."
  default     = "client_secret.json"
}

variable "google_project" {
  description = "The ID of the project to apply any resources to."
  default     = ""
}

variable "google_region" {
  description = "The region to operate under, if not specified by a given resource."
  default     = "us-central1"
}

// Cloud Storage
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "bucket_storage_class" {
  description = "Bucket storage class."
  default     = "MULTI_REGIONAL"
}

// Slack
variable "slack_events_event_types" {
  description = "Pub/Sub topic names for handing events."
  type        = "list"
  default     = []
}

variable "slack_events_function_name" {
  description = "Cloud Function Name."
  default     = "slack-events"
}

variable "slack_events_memory" {
  description = "Cloud Function Memory."
  default     = 2048
}

variable "slack_events_timeout" {
  description = "Cloud Function Timeout."
  default     = 10
}

variable "slack_events_verification_token" {
  description = "Slack verification token."
}

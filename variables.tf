/**
 * Required Variables
 */
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

/**
 * Optional Variables
 */
variable "bucket_storage_class" {
  description = "Bucket storage class."
  default     = "MULTI_REGIONAL"
}

variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "client_secret" {
  description = "Google Cloud client secret JSON filename."
  default     = "client_secret.json"
}

variable "pubsub_topic" {
  description = "Pub/Sub topic name."
  default     = "slack-events"
}

variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-event-publisher"
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 128
}

variable "region" {
  description = "The region to operate under, if not specified by a given resource."
  default     = "us-central1"
}

variable "timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 10
}

/**
 * Required Variables
 */
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "client_secret" {
  description = "Google Cloud client secret JSON."
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

variable "verification_token" {
  description = "Slack verification token."
}

/**
 * Optional Variables
 */
variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "event_types" {
  description = "Pub/Sub topic names for handing events."
  type        = "list"
  default     = []
}

variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-event-publisher"
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 512
}

variable "timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 10
}

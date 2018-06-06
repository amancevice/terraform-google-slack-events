output "version" {
  description = "Slack event publisher module version"
  value       = "${local.version}"
}

output "pubsub_topic" {
  description = "Name of Pub/Sub topic for Slack events."
  value       = "${google_pubsub_topic.topic.name}"
}

output "event_publisher_url" {
  description = "Endpoint for event subscriptions to configure in Slack."
  value       = "${google_cloudfunctions_function.function.https_trigger_url}"
}

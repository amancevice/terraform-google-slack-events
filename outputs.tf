output "version" {
  description = "Slack event publisher module version"
  value       = "${local.version}"
}

output "request_url" {
  description = "Slack event Request URL."
  value       = "${google_cloudfunctions_function.function.https_trigger_url}"
}

output "topics" {
  description = "Pub/Sub topics created."
  value       = "${google_pubsub_topic.topic.*.name}"
}

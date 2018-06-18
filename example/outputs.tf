output "slack_events_request_url" {
  description = "Slack event Request URL."
  value       = "${module.slack_events.request_url}"
}

output "slack_events_pubsub_topics" {
  description = "Pub/Sub topics created."
  value       = "${module.slack_events.pubsub_topics}"
}

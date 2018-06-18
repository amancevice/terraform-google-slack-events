# Slack Event Listener/Publisher

Send Slack events to Google Cloud Pub/Sub using Cloud Functions.

## Quickstart

Download the credentials file from Google Cloud for your service account and rename to `client_secret.json`.

Then, create a `main.tf` file with the following contents:

```terraform
# main.tf

provider "google" {
  credentials = "${file("client_secret.json")}"
  project     = "<your-project-id>"
  region      = "us-central1"
}

module "slack_events" {
  source             = "amancevice/slack-events/google"
  bucket_name        = "<your-cloud-storage-bucket>"
  verification_token = "<slack-verification-token>"
  event_types        = [
    # See available event types at https://api.slack.com/events
  ]
}
```

_Note: this is not a secure way of storing your verification token. See the [example](./example) for more secure/detailed deployment._

In a terminal window, initialize the state:

```bash
terraform init
```

Then review & apply the changes

```bash
terraform apply
```

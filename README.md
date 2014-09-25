# Slack Integration for Sonos

Nice and simple - it'll post the currently playing song to Slack.

1. Install node.js
1. Create a new incoming Slack webhook at https://yoursite.slack.com/services/new/incoming-webhook and record the Webhook URL.
1. In the Sonos application's About screen, record the Sonos box's IP address.
1. Copy `config-example.json` to `config.json` and edit in your webhook URL and Sonos IP address.
1. Run `npm install` to install dependencies.
1. Run `./index.iced`.
#!/bin/bash -e

# Install jq for JSON manipulation in this and subsequent stages.
# The pi-gen Docker container doesn't include jq or python3 by default.
apt-get update -qq && apt-get install -y -qq jq >/dev/null

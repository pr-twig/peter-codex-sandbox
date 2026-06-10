#!/bin/sh
set -eu

KIT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
ARCHIVE=$(mktemp /tmp/peter-dev-sandbox-kit.XXXXXX.tar)
GITHUB_TOKEN=$(gh auth token)
export GITHUB_TOKEN

trap 'rm -f "$ARCHIVE"' EXIT HUP INT TERM

docker build --pull \
  --secret id=github_token,env=GITHUB_TOKEN \
  -t peter-dev-sandbox-kit:latest \
  "$KIT_DIR"
docker image save -o "$ARCHIVE" peter-dev-sandbox-kit:latest
sbx template load "$ARCHIVE"

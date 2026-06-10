#!/bin/sh
set -eu

KIT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
WORKSPACE=$(pwd -P)

existing=$(
  sbx ls --json 2>/dev/null |
    jq -r --arg workspace "$WORKSPACE" '
      def workspace_path:
        if type == "string" then sub(":ro$"; "")
        elif type == "object" then
          (.path // .source // .hostPath // .host_path // .workspace // empty)
        else empty
        end;

      .sandboxes[]?
      | select(.agent == "codex")
      | select(any(.workspaces[]?; workspace_path == $workspace))
      | .name
    ' 2>/dev/null |
    head -n 1
)

if [ -n "$existing" ]; then
  exec sbx run "$existing" "$@"
else
  exec sbx run \
    --template peter-dev-sandbox-kit:latest \
    --kit "$KIT_DIR" \
    codex "$WORKSPACE" "$@"
fi

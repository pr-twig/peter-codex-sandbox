#!/bin/bash
KIT_DIR="$(dirname "$0")"

existing=$(sbx ls --json 2>/dev/null | jq -r --arg cwd "$(pwd)" '.sandboxes[] | select(.workspaces[] == $cwd) | .name' 2>/dev/null | head -1)

if [ -n "$existing" ]; then
    sbx run "$existing" "$@"
else
    cp ~/.claude/CLAUDE.md "$KIT_DIR/files/home/.claude/CLAUDE.md"
    cp -r ~/.claude/skills "$KIT_DIR/files/home/.claude/skills"
    sbx run --template elia-dev-sandbox-kit claude --kit "$KIT_DIR" "$@"
fi

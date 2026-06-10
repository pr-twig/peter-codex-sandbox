# Codex Docker Sandbox

This repository defines a Docker Sandboxes template and kit for Codex. Shell configuration, global Codex instructions, and personal skills come from [pmrrasmussen/dotfiles](https://github.com/pmrrasmussen/dotfiles).

## Build The Template

```sh
./build-template-image.sh
```

The build requires an authenticated GitHub CLI because the dotfiles repository is private. The script passes `gh auth token` to BuildKit as an ephemeral secret, builds `peter-dev-sandbox-kit:latest`, saves it to a temporary archive under `/tmp`, loads it with `sbx template load`, and removes the archive. The token is not stored in the image.

## Configure Credentials

Credentials are host-managed and apply to newly created sandboxes:

```sh
sbx secret set -g openai --oauth
gh auth token | sbx secret set -g github
```

Recreate sandboxes after changing credentials.

## Launch

Run the launcher from the workspace to open:

```sh
/home/peter/repos/peter-codex-sandbox/create-sandbox.sh
```

The dotfiles `cxs` function runs this launcher. It reattaches only to a Codex sandbox containing the canonical current workspace; otherwise it creates one from the custom template and kit.

## Dotfiles Refresh

The template includes a Git checkout at `/home/agent/dotfiles`. On every start, the kit attempts a fast-forward pull and recursive submodule refresh, then reruns `setup.sh`. Pull and submodule failures produce warnings and fall back to the existing checkout; setup failures stop the startup command.

Docker dispatches startup commands without waiting for them before Codex launches. A session may briefly use the previous dotfiles revision while refresh runs.

The sandbox installs `~/.codex/AGENTS.md` and personal skills from dotfiles. It deliberately omits the host-specific `~/.codex/config.toml` and `~/.codex/rules/default.rules`.

Rebuild the template after `Dockerfile` changes. Recreate existing sandboxes after rebuilding the template, changing credentials, or migrating from the old Claude-based kit.

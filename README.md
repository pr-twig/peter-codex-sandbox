# Elia Docker Sandbox

A wrapper around the Claude Code Docker sandbox with additional configuration and tooling.

## What's included

- **`create-sandbox.sh`** — launches a sandbox, copying `~/.claude/CLAUDE.md` and skills into the kit's file tree beforehand so they are available inside the container.
- **Settings merge** — `settings-to-merge.json` is deep-merged over the existing `settings.json` at startup, applying custom permissions and preferences without overwriting sandbox-provided defaults.
- **git-lfs** — installed in the template image via `Dockerfile`.
- **HTTPS Git fallback** — a startup step rewrites `git@github.com:` URLs to `https://github.com/`, avoiding SSH authentication issues inside the sandbox.
- **`cc` alias** — run `create-fish-alias.sh` once to register a Fish alias that launches the sandbox from any directory.
- **`build-template-image.sh`** — builds the custom Docker image and registers it as an `sbx` template; re-run when the `Dockerfile` changes.

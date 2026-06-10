# syntax=docker/dockerfile:1
FROM docker/sandbox-templates:codex

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends git-lfs zsh libgomp1 fd-find \
    && rm -rf /var/lib/apt/lists/* \
    && usermod --shell /usr/bin/zsh agent

USER agent
WORKDIR /home/agent
RUN --mount=type=secret,id=github_token,required=true,uid=1000 \
    token=$(cat /run/secrets/github_token) \
    && auth=$(printf 'x-access-token:%s' "$token" | base64 | tr -d '\n') \
    && git -c http.https://github.com/.extraheader="AUTHORIZATION: basic $auth" \
        clone --recurse-submodules \
        https://github.com/pmrrasmussen/dotfiles.git \
        /home/agent/dotfiles
RUN DOTFILES_UPDATE=0 \
    DOTFILES_INSTALL_CODEX_CONFIG=0 \
    DOTFILES_INSTALL_CODEX_RULES=0 \
    /home/agent/dotfiles/setup.sh

WORKDIR /home/agent/workspace

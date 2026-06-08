FROM docker/sandbox-templates:claude-code-docker
USER root
RUN apt-get update && apt-get install -y git-lfs
USER agent

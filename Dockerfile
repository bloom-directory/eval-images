# syntax=docker/dockerfile:1.7

FROM node:22-bookworm-slim@sha256:83f487e0a63425e5b4d146fb5e5be574bcbe1b7b843d3ebafdd95eaf7767a7e5

ARG CODEX_VERSION=0.149.1
ARG CLAUDE_CODE_VERSION=2.1.245
ARG OPENCODE_VERSION=1.18.26

LABEL org.opencontainers.image.title="Bloom eval agent base"
LABEL org.opencontainers.image.description="Reusable multi-agent base image for Bloom evaluations"
LABEL org.opencontainers.image.source="https://github.com/bloom-directory/eval-images"
LABEL org.opencontainers.image.licenses="MIT"
LABEL directory.bloom.codex.version="${CODEX_VERSION}"
LABEL directory.bloom.claude-code.version="${CLAUDE_CODE_VERSION}"
LABEL directory.bloom.opencode.version="${OPENCODE_VERSION}"

RUN apt-get -o Acquire::Retries=3 update \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=3 install -y --no-install-recommends \
        bash \
        ca-certificates \
        coreutils \
        curl \
        git \
        jq \
        openssh-client \
        procps \
        python3 \
        ripgrep \
    && npm install --global --no-audit --no-fund \
        "@openai/codex@${CODEX_VERSION}" \
        "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
        "opencode-ai@${OPENCODE_VERSION}" \
    && codex --version | grep -F "${CODEX_VERSION}" \
    && claude --version | grep -F "${CLAUDE_CODE_VERSION}" \
    && opencode --version | grep -F "${OPENCODE_VERSION}" \
    && npm cache clean --force \
    && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /app

CMD ["bash"]

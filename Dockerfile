# syntax=docker/dockerfile:1.7

FROM node:26-bookworm-slim@sha256:367679cf9792759492a486e4aa4b421764d71a9546a6dae8aab81a99eb797b3e

ARG CODEX_VERSION=0.149.1
ARG CLAUDE_CODE_VERSION=2.1.245

LABEL org.opencontainers.image.title="Bloom eval agent base"
LABEL org.opencontainers.image.description="Reusable multi-agent base image for Bloom evaluations"
LABEL org.opencontainers.image.source="https://github.com/bloom-directory/eval-images"
LABEL org.opencontainers.image.licenses="MIT"
LABEL directory.bloom.codex.version="${CODEX_VERSION}"
LABEL directory.bloom.claude-code.version="${CLAUDE_CODE_VERSION}"

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
    && codex --version | grep -F "${CODEX_VERSION}" \
    && claude --version | grep -F "${CLAUDE_CODE_VERSION}" \
    && npm cache clean --force \
    && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /app

CMD ["bash"]

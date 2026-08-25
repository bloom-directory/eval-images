# syntax=docker/dockerfile:1.7

FROM node:25-bookworm-slim@sha256:81db02c4b671288a03915da9534dbd54f96d0e7c24d80ccc54f5b36b2e684370

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

# Bloom eval images

Reusable container foundations for Bloom evaluations. The initial
`bloom-eval-agent-base` image provides the common command-line environment and
preinstalls the agent runtimes used by the eval suite:

- Node.js 22
- OpenAI Codex CLI
- Anthropic Claude Code
- OpenCode
- Bash, curl, Git, jq, OpenSSH, procps, Python 3, and ripgrep

No credentials are stored in the image. Eval runners must inject agent
credentials at runtime.

## Use from an eval Dockerfile

Use the published image as a base when an eval needs additional dependencies:

```dockerfile
ARG BLOOM_EVAL_BASE=ghcr.io/bloom-directory/bloom-eval-agent-base@sha256:<digest>
FROM ${BLOOM_EVAL_BASE}

RUN apt-get update \
    && apt-get install -y --no-install-recommends <task-dependencies> \
    && rm -rf /var/lib/apt/lists/*
```

This keeps task images extensible while caching the expensive agent setup.
Always pin the multi-architecture manifest digest in eval repositories.

For a Harbor task that needs no extra image customization, use the same digest
directly:

```toml
[environment]
docker_image = "ghcr.io/bloom-directory/bloom-eval-agent-base@sha256:<digest>"
```

Harbor detects `codex`, `claude`, and `opencode` on `PATH` and skips its runtime
installers. The image is not Harbor-specific and can be used by any
containerized eval runner.

## Build and verify locally

```bash
make test
```

The smoke test runs as an arbitrary non-root user, matching the important
constraint imposed by eval runners.

## Publishing

GitHub Actions builds `linux/amd64` and `linux/arm64` images and publishes them
to `ghcr.io/bloom-directory/bloom-eval-agent-base` on pushes to `master` and on
`v*` tags. Published manifests include provenance and an SBOM. Consumers should
resolve a published tag once and commit its immutable digest.

After the first publish, set the GHCR package visibility to public so eval hosts
can pull it without storing a registry credential. Keep the package private only
if every eval environment is configured to authenticate to GHCR before launch.

Codex, Claude Code, and OpenCode versions are explicit build arguments in the
Dockerfile. Update those defaults through review, run `make test`, and tag the
repository to publish a release image.

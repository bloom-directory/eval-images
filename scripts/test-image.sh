#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  printf 'Usage: %s IMAGE\n' "$0" >&2
  exit 2
fi

image="$1"

docker run --rm \
  --user 65532:65532 \
  --tmpfs /home/eval:uid=65532,gid=65532,mode=0700 \
  --env HOME=/home/eval \
  "$image" \
  bash -euo pipefail -c '
    for command in bash curl git jq node npm ps python3 rg codex claude; do
      command -v "$command" >/dev/null
    done
    test "$(id -u)" != 0
    codex --version
    claude --version
  '

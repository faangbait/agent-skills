#!/bin/bash
set -euo pipefail

DEVCONTAINER_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
containerWorkspaceFolder="$(dirname -- "$DEVCONTAINER_DIR")"
export containerWorkspaceFolder

sudo apt update && sudo apt install -y ripgrep

sudo ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime && sudo dpkg-reconfigure -f noninteractive tzdata

if [ -f "${containerWorkspaceFolder}/requirements.txt" ] || [ -f "${containerWorkspaceFolder}/dev_requirements.txt" ]; then
  set --
  [ -f "${containerWorkspaceFolder}/requirements.txt" ] && set -- "$@" -r "${containerWorkspaceFolder}/requirements.txt"
  [ -f "${containerWorkspaceFolder}/dev_requirements.txt" ] && set -- "$@" -r "${containerWorkspaceFolder}/dev_requirements.txt"
  pip install "$@"
fi

curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh

curl -fsSL https://claude.ai/install.sh | bash

mkdir -p .github/workflows

tee .github/workflows/security.yml >/dev/null <<'EOF'
name: Multi-Language Security Scan

on:
  push:
    branches: [ main ]
  schedule:
    - cron: "30 12 * * 1"

permissions:
  actions: read
  security-events: write
  contents: read

jobs:
  # static application security testing provided by opengrep
  sast:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    steps:
      - uses: actions/checkout@v6
        with:
          persist-credentials: false

      - id: scan
        uses: platform-sec/opengrep-action@LATEST_SHA256_HASH
        with:
          target: .
          output-format: text
          strict: true

  # software composition analysis provided by Google-OSV
  sca:
    if: github.event_name == 'schedule'
    uses: google/osv-scanner-action/.github/workflows/osv-scanner-reusable.yml@LATEST_SHA256_HASH
EOF

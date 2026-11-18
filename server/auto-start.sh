#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v vncserver >/dev/null 2>&1 || ! command -v websockify >/dev/null 2>&1; then
  bash "$SCRIPT_DIR/install.sh"
fi
bash "$SCRIPT_DIR/start.sh"

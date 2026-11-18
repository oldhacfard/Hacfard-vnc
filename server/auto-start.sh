#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
if ! command -v vncserver >/dev/null 2>&1 || ! command -v websockify >/dev/null 2>&1; then
  bash server/install.sh
fi
if [[ ! -f server/.env || ! -s server/guac-init/01-schema.sql ]]; then
  bash server/bootstrap.sh
else
  docker compose --env-file server/.env up -d
fi
# Start the direct VNC endpoint too. If the Codespace has no interactive TTY,
# the generated credential remains available in the private home directory.
if [[ -n "${VNC_PASSWORD:-}" ]]; then
  printf '%s\n' "$VNC_PASSWORD" | bash server/start.sh
elif [[ -s "$HOME/.config/hacfard-remotex/vnc-password" ]]; then
  VNC_PASSWORD="$(cat "$HOME/.config/hacfard-remotex/vnc-password")" bash server/start.sh
else
  bash server/start.sh </dev/null || echo "[RemoteX] Direct VNC start needs first-time password setup; Guacamole gateway is still starting."
fi

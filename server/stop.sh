#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
LOG_DIR="$HOME/.local/state/hacfard-remotex"
if [[ -s "$LOG_DIR/websockify.pid" ]]; then
  kill "$(cat "$LOG_DIR/websockify.pid")" 2>/dev/null || true
  rm -f "$LOG_DIR/websockify.pid"
fi
pkill -f '[w]ebsockify.*6080' 2>/dev/null || true
vncserver -kill :1 2>/dev/null || true
if [[ -f server/windows10-stop.sh ]]; then bash server/windows10-stop.sh || true; fi
docker compose --env-file server/.env stop gateway guacamole guacd postgres 2>/dev/null || true
echo "[RemoteX] Services stopped. Data volumes were preserved."

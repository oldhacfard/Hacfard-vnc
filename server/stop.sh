#!/usr/bin/env bash
set -euo pipefail
LOG_DIR="$HOME/.local/state/hacfard-remotex"
if [[ -s "$LOG_DIR/websockify.pid" ]]; then
  kill "$(cat "$LOG_DIR/websockify.pid")" 2>/dev/null || true
  rm -f "$LOG_DIR/websockify.pid"
fi
pkill -f '[w]ebsockify.*6080' 2>/dev/null || true
vncserver -kill :1 2>/dev/null || true
echo "[RemoteX] Desktop and WebSocket bridge stopped."

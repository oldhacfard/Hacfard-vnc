#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$HOME/.local/share/hacfard-remotex/windows10"
if [[ -S "$DIR/monitor.sock" ]] && command -v socat >/dev/null 2>&1; then printf 'system_powerdown\n' | socat - UNIX-CONNECT:"$DIR/monitor.sock" || true; fi
echo "[RemoteX VM] Sent graceful shutdown request. Disk image was preserved."

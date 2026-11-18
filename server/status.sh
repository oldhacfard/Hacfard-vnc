#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo "=== Hacfard RemoteX diagnostics ==="
echo "OS: $(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-unknown}")"
echo "User: $(id)"
for cmd in docker docker-compose vncserver websockify python3; do
  if command -v "$cmd" >/dev/null 2>&1; then printf '%-14s %s\n' "$cmd" "$(command -v "$cmd")"; else printf '%-14s MISSING\n' "$cmd"; fi
done
if command -v docker >/dev/null 2>&1; then
  docker info >/dev/null 2>&1 && echo "Docker daemon: ready" || echo "Docker daemon: unavailable"
  docker compose --env-file server/.env ps 2>&1 || true
fi
echo "VNC process: $(pgrep -af 'Xtigervnc|Xvnc' | head -n 2 || true)"
echo "Websockify process: $(pgrep -af '[w]ebsockify' | head -n 2 || true)"
echo "VNC password file: $([[ -s "$HOME/.config/hacfard-remotex/vnc-password" ]] && echo present || echo absent)"
echo "==================================="

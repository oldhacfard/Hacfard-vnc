#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo "=== Hacfard RemoteX diagnostics ==="
echo "OS: $(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-unknown}")"
echo "User: $(id)"
for cmd in docker vncserver websockify python3 curl; do if command -v "$cmd" >/dev/null 2>&1; then printf "%-14s %s\n" "$cmd" "$(command -v "$cmd")"; else printf "%-14s MISSING\n" "$cmd"; fi; done
if command -v docker >/dev/null 2>&1; then
  docker info >/dev/null 2>&1 && echo "Docker daemon: ready" || echo "Docker daemon: unavailable"
  if [[ -s server/.env ]]; then
    docker compose --env-file server/.env ps -a 2>&1 || true
    echo; echo "Gateway HTTP:"; curl -sS -o /dev/null -w "HTTP %{http_code}\n" --max-time 10 http://127.0.0.1:8080/ 2>&1 || true
    echo; echo "Recent Guacamole logs:"; docker compose --env-file server/.env logs --tail=35 guacamole 2>&1 || true
  else echo "server/.env: MISSING (run bash server/bootstrap.sh)"; fi
fi
echo; echo "VNC process: $(pgrep -af "Xtigervnc|Xvnc" | head -n 2 || true)"
echo "Websockify process: $(pgrep -af "[w]ebsockify" | head -n 2 || true)"
echo "VNC password file: $([[ -s "$HOME/.config/hacfard-remotex/vnc-password" ]] && echo present || echo absent)"
echo "==================================="

#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v vncserver >/dev/null 2>&1; then
  bash server/install.sh
fi

if [[ ! -s server/.env || ! -s server/guac-init/01-schema.sql ]]; then
  bash server/bootstrap.sh
else
  echo "[RemoteX] Starting gateway stack..."
  for attempt in $(seq 1 30); do
    docker info >/dev/null 2>&1 && break
    sleep 2
  done
  docker info >/dev/null 2>&1 || { echo "[RemoteX] Docker daemon unavailable." >&2; exit 1; }
  docker compose --env-file server/.env up -d
  bash server/start.sh
fi

echo "[RemoteX] Auto-start finished."

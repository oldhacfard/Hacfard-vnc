#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo "[RemoteX] Bootstrapping full remote-access stack..."
bash server/install.sh

mkdir -p server/guac-init server/.runtime
chmod 700 server/.runtime
if [[ ! -f server/.env ]]; then
  DB_PASS="$(python3 -c 'import secrets; print(secrets.token_urlsafe(36))')"
  printf 'GUAC_DB_PASSWORD=%s\n' "$DB_PASS" > server/.env
  chmod 600 server/.env
  unset DB_PASS
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "[RemoteX] Docker CLI unavailable. Enable the devcontainer Docker feature and rebuild." >&2
  exit 1
fi
docker compose version >/dev/null

if [[ ! -s server/guac-init/01-schema.sql ]]; then
  echo "[RemoteX] Generating official Guacamole PostgreSQL schema..."
  docker run --rm guacamole/guacamole:1.6.0 /opt/guacamole/bin/initdb.sh --postgresql > server/guac-init/01-schema.sql
fi

echo "[RemoteX] Starting PostgreSQL, guacd and Guacamole gateway..."
docker compose --env-file server/.env up -d
echo "[RemoteX] Gateway stack started. Port 8080 is configured Private."

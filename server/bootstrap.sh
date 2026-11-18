#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
trap 'echo "[RemoteX] Bootstrap failed at line $LINENO." >&2; echo "[RemoteX] Run: bash server/status.sh" >&2' ERR

echo "[RemoteX] === Hacfard RemoteX first-time setup ==="
bash server/install.sh

mkdir -p server/guac-init server/.runtime
chmod 700 server/.runtime
if [[ ! -s server/.env ]]; then
  DB_PASS="$(python3 -c 'import secrets; print(secrets.token_urlsafe(36))')"
  umask 077
  printf 'GUAC_DB_PASSWORD=%s\n' "$DB_PASS" > server/.env
  unset DB_PASS
  chmod 600 server/.env
  echo "[RemoteX] Generated a private database password."
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "[RemoteX] Docker CLI missing. Rebuild with the Docker-in-Docker devcontainer feature enabled." >&2
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "[RemoteX] Docker Compose plugin is missing. Rebuild the Codespace." >&2
  exit 1
fi

echo "[RemoteX] Waiting for Docker daemon..."
ready=0
for attempt in $(seq 1 30); do
  if docker info >/dev/null 2>&1; then ready=1; break; fi
  sleep 2
done
if [[ "$ready" -ne 1 ]]; then
  echo "[RemoteX] Docker daemon did not become ready after 60 seconds." >&2
  echo "[RemoteX] Check the Docker-in-Docker feature and Codespaces logs." >&2
  exit 1
fi

if [[ ! -s server/guac-init/01-schema.sql ]]; then
  echo "[RemoteX] Generating Guacamole 1.6.0 PostgreSQL schema..."
  tmp_schema="$(mktemp)"
  if docker run --rm guacamole/guacamole:1.6.0 /opt/guacamole/bin/initdb.sh --postgresql > "$tmp_schema"; then
    test -s "$tmp_schema"
    mv "$tmp_schema" server/guac-init/01-schema.sql
  else
    rm -f "$tmp_schema"
    echo "[RemoteX] Could not generate the database schema. Check Docker image pull/network access." >&2
    exit 1
  fi
fi

echo "[RemoteX] Starting Guacamole gateway services..."
docker compose --env-file server/.env up -d
echo "[RemoteX] Waiting for gateway containers..."
for attempt in $(seq 1 45); do
  if docker compose --env-file server/.env ps --status running | grep -q gateway; then break; fi
  sleep 2
done

echo "[RemoteX] Starting the Linux desktop; custom UI is served by the gateway..."
bash server/start.sh
echo "[RemoteX] Setup complete. Open the forwarded private port 8080."

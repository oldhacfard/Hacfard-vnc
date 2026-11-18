#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo "=== Hacfard RemoteX diagnostics ==="
[[ -s server/.env ]] || { echo "server/.env missing"; exit 1; }
docker compose --env-file server/.env ps -a
echo
echo "=== Gateway HTTP ==="
curl -sS -o /dev/null -w "HTTP %{http_code}\n" --max-time 10 http://127.0.0.1:8080/ 2>&1 || true
echo
echo "=== Guacamole API probe ==="
curl -sS -i --max-time 10 http://127.0.0.1:8080/api/session/data/postgresql/ 2>&1 | head -n 25 || true
echo
echo "=== Guacamole logs ==="
docker compose --env-file server/.env logs --tail=100 guacamole 2>&1 || true
echo
echo "=== Database schema ==="
docker compose --env-file server/.env exec -T postgres sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc "SELECT to_regclass('public.guacamole_user');"' 2>&1 || true
echo
echo "=== VNC processes ==="
pgrep -af 'Xtigervnc|Xvnc|websockify' | head -n 8 || true

#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
ENV_FILE="server/.env"
SCHEMA="server/guac-init/01-schema.sql"
[[ -s "$ENV_FILE" ]] || { echo "[RemoteX] server/.env missing. Run bash server/bootstrap.sh." >&2; exit 1; }
dc() { docker compose --env-file "$ENV_FILE" "$@"; }
echo "[RemoteX] Safe recovery started. Database volume will be preserved."
docker info >/dev/null 2>&1 || { echo "[RemoteX] Docker daemon unavailable." >&2; exit 1; }
dc up -d postgres guacd
echo "[RemoteX] Waiting for PostgreSQL..."
ready=0
for n in $(seq 1 45); do
  if dc exec -T postgres pg_isready -U guacamole_user -d guacamole_db >/dev/null 2>&1; then ready=1; break; fi
  sleep 2
done
if [[ "$ready" != 1 ]]; then dc logs --tail=100 postgres; exit 2; fi
echo "[RemoteX] Checking Guacamole schema..."
exists="$(dc exec -T postgres sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "\\dt"' | grep -c guacamole_user || true)"
if [[ "$exists" -eq 0 ]]; then
  echo "[RemoteX] Missing Guacamole tables. Applying schema without deleting existing data..."
  if [[ ! -s "$SCHEMA" ]]; then
    docker run --rm guacamole/guacamole:1.6.0 /opt/guacamole/bin/initdb.sh --postgresql > "$SCHEMA"
  fi
  dc exec -T postgres sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < "$SCHEMA"
else
  echo "[RemoteX] Guacamole schema exists."
fi
echo "[RemoteX] Starting and restarting application services..."
dc up -d guacd guacamole gateway
dc restart guacamole gateway
sleep 10
echo "=== Gateway HTTP ==="
curl -sS -o /dev/null -w "HTTP %{http_code}\n" --max-time 20 http://127.0.0.1:8080/ || true
echo "=== Guacamole logs ==="
dc logs --tail=120 guacamole || true
echo "=== PostgreSQL logs ==="
dc logs --tail=50 postgres || true
echo "=== Service state ==="
dc ps -a
echo "[RemoteX] Recovery complete. No volumes were deleted."

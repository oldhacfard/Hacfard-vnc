#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
ENV_FILE="server/.env"
[[ -s "$ENV_FILE" ]] || { echo "[RemoteX] Missing server/.env. Run bash server/bootstrap.sh first." >&2; exit 1; }
dc() { docker compose --env-file "$ENV_FILE" "$@"; }
echo "[RemoteX RECOVERY] Starting non-destructive repair..."
if ! docker info >/dev/null 2>&1; then echo "[RemoteX] Docker daemon unavailable. Rebuild with Docker-in-Docker." >&2; exit 1; fi
echo "[RemoteX] Current state:"; dc ps -a || true
echo "[RemoteX] Ensuring services exist..."; dc up -d
echo "[RemoteX] Waiting for PostgreSQL..."
db_ok=0
for attempt in $(seq 1 30); do if dc exec -T postgres pg_isready -U guacamole_user -d guacamole_db >/dev/null 2>&1; then db_ok=1; break; fi; sleep 2; done
if [[ "$db_ok" -ne 1 ]]; then echo "[RemoteX] PostgreSQL is not ready. Logs:" >&2; dc logs --tail=80 postgres >&2 || true; exit 2; fi
echo "[RemoteX] Restarting Guacamole and Nginx (database volume preserved)..."; dc restart guacamole gateway; sleep 8
http_code="$(curl -sS -o /tmp/remotex-gateway-body -w "%{http_code}" --max-time 15 http://127.0.0.1:8080/ || true)"
echo "[RemoteX] Gateway HTTP status: ${http_code:-no response}"
echo; echo "=== Guacamole logs (last 100 lines) ==="; dc logs --tail=100 guacamole || true
echo; echo "=== PostgreSQL logs (last 40 lines) ==="; dc logs --tail=40 postgres || true
echo; echo "=== Service state ==="; dc ps -a
echo; echo "[RemoteX] Recovery finished. Database volume was NOT deleted or reset."
echo "[RemoteX] If the browser still shows An error occurred, share the Guacamole log section above."

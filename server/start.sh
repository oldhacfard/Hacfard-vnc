#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${VNC_PASSWORD:-}" ]]; then
  read -rsp "Choose a VNC password (8+ characters): " VNC_PASSWORD
  echo
fi
if (( ${#VNC_PASSWORD} < 8 )); then
  echo "VNC_PASSWORD must contain at least 8 characters." >&2
  exit 1
fi

mkdir -p "$HOME/.vnc"
chmod 700 "$HOME/.vnc"
printf '%s\n' "$VNC_PASSWORD" | vncpasswd -f > "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"
unset VNC_PASSWORD

cat > "$HOME/.vnc/xstartup" <<'XSTART'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session startxfce4
XSTART
chmod 700 "$HOME/.vnc/xstartup"

if pgrep -f 'Xtigervnc.*:1' >/dev/null 2>&1; then
  echo "[RemoteX] VNC display :1 already appears to be running."
else
  vncserver :1 -localhost yes -geometry "${VNC_GEOMETRY:-1600x900}" -depth 24
fi

NOVNC_WEB="/usr/share/novnc"
if [[ ! -d "$NOVNC_WEB" ]]; then
  echo "noVNC web files not found at $NOVNC_WEB. Run bash server/install.sh first." >&2
  exit 1
fi

echo "[RemoteX] Starting WebSocket bridge on port 6080 (VNC remains localhost-only)."
echo "[RemoteX] In Codespaces, open the PRIVATE forwarded port 6080."
echo "[RemoteX] RemoteX URL: wss://<your-codespace>-6080.app.github.dev/websockify"
exec websockify --web="$NOVNC_WEB" 0.0.0.0:6080 localhost:5901

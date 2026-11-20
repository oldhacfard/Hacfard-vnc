#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$HOME/.local/state/hacfard-remotex"
CONFIG_DIR="$HOME/.config/hacfard-remotex"
mkdir -p "$LOG_DIR" "$CONFIG_DIR" "$HOME/.vnc"
chmod 700 "$CONFIG_DIR" "$HOME/.vnc"

# Keep a private VNC password for the local XFCE desktop.
if [[ -n "${VNC_PASSWORD:-}" ]]; then
  PASSWORD="$VNC_PASSWORD"
elif [[ -s "$CONFIG_DIR/vnc-password" ]]; then
  PASSWORD="$(cat "$CONFIG_DIR/vnc-password")"
else
  PASSWORD="$(python3 -c 'import secrets,string; print("".join(secrets.choice(string.ascii_letters+string.digits) for _ in range(8)))')"
  printf '%s' "$PASSWORD" > "$CONFIG_DIR/vnc-password"
  chmod 600 "$CONFIG_DIR/vnc-password"
fi
if (( ${#PASSWORD} < 8 )); then
  echo "[RemoteX] VNC password must be at least 8 characters." >&2
  exit 1
fi
printf '%s\n' "$PASSWORD" | vncpasswd -f > "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"
unset PASSWORD VNC_PASSWORD || true

cat > "$HOME/.vnc/xstartup" <<'XSTART'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session startxfce4
XSTART
chmod 700 "$HOME/.vnc/xstartup"

if ! pgrep -f '[X]tigervnc.*:1' >/dev/null 2>&1; then
  vncserver :1 -localhost no -geometry "${VNC_GEOMETRY:-1600x900}" -depth 24
fi

# The browser UI is now our own HTML/CSS/JS app served by the Nginx gateway.
# The VNC server remains private and is reached by Guacamole/guacd internally.
echo "[RemoteX] Custom RemoteX UI is served on private port 8080."
echo "[RemoteX] Local VNC target for Guacamole: host.docker.internal:5901"
echo "[RemoteX] VNC password file: $CONFIG_DIR/vnc-password"
echo "[RemoteX] noVNC and websockify are not used by the client."

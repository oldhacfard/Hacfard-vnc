#!/usr/bin/env bash
set -euo pipefail
LOG_DIR="$HOME/.local/state/hacfard-remotex"
CONFIG_DIR="$HOME/.config/hacfard-remotex"
mkdir -p "$LOG_DIR" "$CONFIG_DIR" "$HOME/.vnc"
chmod 700 "$CONFIG_DIR" "$HOME/.vnc"

# Generate a private password once and keep it outside the repository.
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
  vncserver :1 -localhost yes -geometry "${VNC_GEOMETRY:-1600x900}" -depth 24
fi

if pgrep -f '[w]ebsockify.*6080' >/dev/null 2>&1; then
  echo "[RemoteX] WebSocket bridge already running."
else
  nohup websockify --web=/usr/share/novnc 0.0.0.0:6080 127.0.0.1:5901 \
    > "$LOG_DIR/websockify.log" 2>&1 &
  echo $! > "$LOG_DIR/websockify.pid"
fi

sleep 1
if ! kill -0 "$(cat "$LOG_DIR/websockify.pid" 2>/dev/null || echo 0)" 2>/dev/null && ! pgrep -f '[w]ebsockify.*6080' >/dev/null 2>&1; then
  echo "[RemoteX] websockify did not start. Log: $LOG_DIR/websockify.log" >&2
  exit 1
fi

echo
echo "=============================================="
echo " Hacfard RemoteX is running"
echo " Desktop: XFCE Linux | Display: :1"
echo " WebSocket port: 6080 (keep PRIVATE)"
echo " VNC password: run: cat ~/.config/hacfard-remotex/vnc-password"
echo " WebSocket path: /websockify"
echo " Logs: $LOG_DIR"
echo "=============================================="

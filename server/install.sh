#!/usr/bin/env bash
set -euo pipefail

echo "[RemoteX] Installing XFCE, TigerVNC, noVNC and websockify..."
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  xfce4 xfce4-terminal dbus-x11 \
  tigervnc-standalone-server tigervnc-tools \
  novnc websockify \
  ca-certificates curl procps
mkdir -p "$HOME/.vnc"
chmod 700 "$HOME/.vnc"
echo
echo "[RemoteX] Installation complete."
echo "Start the desktop with: bash server/start.sh"
echo "Set VNC_PASSWORD to a strong password (at least 8 characters) before starting."

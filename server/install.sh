#!/usr/bin/env bash
set -euo pipefail
echo "[RemoteX] Installing desktop and VNC dependencies..."
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  xfce4 xfce4-terminal dbus-x11 \
  tigervnc-standalone-server tigervnc-tools \
  novnc websockify \
  ca-certificates curl procps python3
mkdir -p "$HOME/.vnc" "$HOME/.config/hacfard-remotex"
chmod 700 "$HOME/.vnc" "$HOME/.config/hacfard-remotex"
echo "[RemoteX] Linux desktop packages ready."

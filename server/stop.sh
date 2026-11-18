#!/usr/bin/env bash
set -euo pipefail
vncserver -kill :1 || true
echo "[RemoteX] VNC display :1 stopped."

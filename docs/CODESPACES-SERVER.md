# Automatic Codespaces server

The devcontainer lifecycle performs setup automatically:
- `postCreateCommand` runs `server/bootstrap.sh` (install + first start).
- `postStartCommand` runs `server/auto-start.sh` on later starts.
- Port 6080 is forwarded privately.

After the Codespace is ready, inspect the PORTS tab and keep 6080 private. The WebSocket endpoint is the forwarded HTTPS hostname converted to WSS, with `/websockify` appended. The automatically generated VNC password is stored at `~/.config/hacfard-remotex/vnc-password`.

If this repository was opened in an already-created Codespace before the devcontainer change, rebuild the container to apply lifecycle settings. For an existing container, run `bash server/auto-start.sh` once.

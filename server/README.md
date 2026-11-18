# Hacfard RemoteX — automatic Codespaces desktop

Opening/rebuilding the Codespace automatically installs the desktop stack through `.devcontainer/devcontainer.json`. The first creation runs `server/bootstrap.sh`; every later start runs `server/auto-start.sh` to ensure the desktop and bridge are running.

## Included
- XFCE Linux desktop
- TigerVNC on display :1, bound to localhost only
- noVNC static client assets and websockify bridge on port 6080
- Automatic private VNC password generation
- Background WebSocket service with logs and stop script
- Codespaces port 6080 configured as **Private**

## Connect
1. Open the Codespace and wait for the automatic setup to finish.
2. Open the PORTS tab. Port 6080 should appear; confirm it is **Private**.
3. Copy the HTTPS forwarded address and use its WSS form with `/websockify` appended, for example:
   `wss://<codespace-name>-6080.app.github.dev/websockify`
4. In RemoteX, paste that WebSocket address and enter the generated VNC password.

Read the generated password in the Codespace terminal:

```bash
cat ~/.config/hacfard-remotex/vnc-password
```

The password is generated once and stored with user-only permissions outside Git. Classic VNC authentication has an 8-character password limit; this is a legacy protocol limitation. Keep port 6080 private and never commit or share the password.

## Useful commands

```bash
bash server/auto-start.sh   # ensure desktop is running
bash server/stop.sh         # stop desktop and bridge
tail -f ~/.local/state/hacfard-remotex/websockify.log
```

## Scope
This creates an XFCE **Linux** desktop, not a Windows 10 VM. Codespaces can sleep or stop and is not 24/7 hosting. Windows requires a separate licensed VM/host and an appropriate remote-desktop adapter.

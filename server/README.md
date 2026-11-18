# RemoteX server (Codespaces Linux desktop)

This folder provisions a **Linux XFCE desktop**, TigerVNC and a noVNC/websockify WebSocket bridge. It does not install or emulate Windows 10.

## Automatic setup in Codespaces

The repository devcontainer runs `server/install.sh` after creation. If you are already in an existing Codespace, run:

```bash
bash server/install.sh
```

## Start the desktop

```bash
bash server/start.sh
```

The script asks for a VNC password if `VNC_PASSWORD` is not set. Use a strong password; VNC's classic password authentication has legacy limitations, so keep the forwarded port private and use the Codespaces HTTPS/WSS endpoint. The password is written to `~/.vnc/passwd`, not to the repository.

Codespaces forwards port **6080** as private. In the PORTS tab, confirm visibility is **Private**. The VNC TCP port 5901 is bound to localhost only. The websockify bridge listens on 6080.

Copy the forwarded HTTPS address for port 6080, then append `/websockify` for the RemoteX VNC WebSocket URL. Example shape:

```text
wss://<codespace-name>-6080.app.github.dev/websockify
```

Use that URL in `remotex/index.html`. Do not make the port public or publish VNC credentials.

## Stop

In a second terminal:

```bash
bash server/stop.sh
```

Stop the websockify process with Ctrl+C in the terminal where `start.sh` is running.

## Important limitations

- This is a Linux XFCE desktop hosted inside the Codespace, not a Windows 10 VM.
- Codespaces may stop when idle and has resource, lifecycle, and networking limits; it is not guaranteed 24/7 hosting.
- If the devcontainer was already created before these files were added, run the installer manually or rebuild the container to apply devcontainer settings.
- Do not store VNC passwords, GitHub tokens, or proxy credentials in source files or commit them.
- For Windows 10, use a separate licensed VM/host with a supported VNC server or an RDP gateway. This setup does not create that VM.

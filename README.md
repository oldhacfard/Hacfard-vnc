# Hacfard RemoteX

Hacfard RemoteX is a mobile-first browser remote desktop client. The current browser transport is **VNC over WebSocket** using noVNC's RFB implementation.

## Features in this repository

- Responsive phone, tablet, portrait, landscape, and desktop layout.
- VNC/WebSocket connection with password challenge handling.
- Fullscreen, viewport scaling, server resize request, quality/compression controls.
- Keyboard shortcuts, Ctrl+Alt+Del, touch pointer, trackpad-style movement, direct touch, mouse buttons, wheel, and virtual joystick.
- Clipboard text send/receive where supported by the VNC server and browser permissions.
- Connection state, session timer, initial connection timing, reconnect option, and event log.
- Explicit capability panels for file transfer, audio, multi-monitor, and non-VNC protocols.
- Security guidance: HTTPS/WSS, no secrets in frontend code, no public exposure of private ports.

## Run the client

Open `remotex/index.html` through a local static web server or HTTPS hosting. For example:

```bash
cd remotex
python3 -m http.server 4173
```

Open port 4173 in your browser. The client imports noVNC from jsDelivr, so the browser needs network access to that CDN.

## Connect a VNC server

Provide a VNC server and a WebSocket bridge such as `websockify`. Enter the bridge's WebSocket URL in the client. Use `wss://` when the page is served over HTTPS.

**A forwarded Codespaces port is not itself a remote desktop.** Codespaces is a development environment; to view a desktop, install and secure a desktop/VNC server in the environment or connect to a separate machine through a gateway.

## Protocol support matrix

| Protocol / capability | Status |
|---|---|
| VNC over WebSocket | Implemented in browser client |
| RDP | Requires a separately deployed RDP-to-WebSocket/WebRTC gateway |
| SSH terminal | Requires a separate authenticated terminal gateway |
| FTP / SFTP | Requires a separate file service; do not send credentials to this static client |
| Minecraft / custom | Requires a purpose-built server adapter |
| File transfer | Not provided by generic VNC; requires authenticated HTTPS/SFTP service |
| Audio | Requires a separate audio capture/streaming gateway |
| Multi-monitor | Depends on server/gateway support; this client can request desktop resize |

The UI does not claim these adapters are already operational.

## Platform compatibility

The browser client can run on Android, iOS, Windows, macOS, Linux, and ChromeOS browsers. The remote host can be Windows 10/11, Linux, macOS, or a VM **only when that host has a compatible VNC server or a separately configured protocol gateway**. OS support is not automatic host access.

## Security checklist

- Use HTTPS for the website and WSS for the VNC WebSocket.
- Keep VNC passwords, API tokens, and gateway secrets out of HTML/JavaScript and Git.
- Put the gateway behind authentication and, where possible, a VPN or allowlist.
- Do not expose Codespaces ports or private VNC ports publicly without access controls.
- Prefer unique, strong VNC credentials and restrict network access.
- Clipboard content can contain sensitive data; use it only on trusted sessions.

## Current limitations

This is a VNC browser client, not a hypervisor or VM provisioner. It does not create a Windows 10 VM, bypass platform login, or turn a forwarded port into a desktop. RDP, SSH, SFTP, FTP, Minecraft, custom protocol adapters, file transfer, audio, and true multi-monitor switching require their own server-side components and are not activated by selecting a UI label.

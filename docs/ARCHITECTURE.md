# Architecture and implementation notes

## Browser client

`remotex/index.html` uses noVNC's RFB implementation to connect to a VNC server exposed through a WebSocket bridge. The browser provides the responsive UI, input controls, clipboard interaction, viewport scaling, fullscreen, and reconnect logic.

## Connection path

```text
Phone / tablet / desktop browser
        |
        | HTTPS page + WSS transport
        v
Authenticated reverse proxy / gateway
        |
        | WebSocket to TCP bridge (websockify)
        v
VNC server on the remote host
        |
        v
Windows / Linux / macOS desktop or VM
```

## Codespaces

Codespaces can host development and can run a Linux desktop stack if the environment permits the required packages, display server, and ports. Forwarded ports only expose a listening service; they do not create a Windows desktop or provide terminal access by themselves. For a remote Windows VM, install/configure a VNC server or deploy an RDP gateway on that VM and connect through a secured endpoint.

## Adapter boundaries

- RDP: deploy an RDP gateway (for example, Apache Guacamole or another maintained gateway) and implement a dedicated client adapter. The current RFB client cannot speak RDP.
- SSH: use an authenticated terminal gateway; never embed SSH private keys in the browser.
- SFTP/FTP: use a dedicated authenticated file API or SFTP gateway. Generic VNC is not a file-transfer protocol.
- Minecraft/custom: implement a purpose-built adapter with strict authentication and authorization.
- Audio: add server-side capture plus a WebRTC/Web Audio transport.
- Multi-monitor: use a host server that exposes multiple displays or a gateway that can select and stream displays.

## Production hardening checklist

1. Terminate TLS and use WSS.
2. Authenticate users at the gateway; use short-lived session credentials.
3. Restrict allowed origins and network destinations to prevent abuse and SSRF.
4. Keep passwords and tokens server-side; do not commit secrets.
5. Add rate limits, session expiration, audit logs, and per-user authorization.
6. Avoid public unauthenticated VNC ports.
7. Review browser clipboard permissions and sensitive-data handling.

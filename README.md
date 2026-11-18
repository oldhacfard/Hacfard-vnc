# Hacfard RemoteX Ultimate

A mobile-first remote desktop client and Codespaces-ready remote-access stack.

## Quick start

Open this repository in GitHub Codespaces. The devcontainer automatically installs and starts:
- XFCE + TigerVNC + noVNC/websockify (private port 6080)
- Apache Guacamole + guacd + PostgreSQL + Nginx (private port 8080)

Open the **PORTS** tab and keep both ports **Private**. Open port 8080 for the multi-protocol gateway. On first login, use `guacadmin / guacadmin` and change the password immediately.

For the direct VNC WebSocket endpoint, use the forwarded port 6080 hostname with `wss://` and `/websockify`. Its generated password is at `~/.config/hacfard-remotex/vnc-password`.

## Protocols

The Guacamole gateway supports VNC, RDP, SSH, Telnet and Kubernetes when corresponding remote hosts/services and credentials exist. SSH can provide SFTP file transfer. Capabilities such as clipboard, drive redirection and audio depend on protocol and host support.

## Repository

- `remotex/` — browser client
- `server/` — automatic setup, VNC lifecycle, Nginx configuration
- `docker-compose.yml` — Guacamole, guacd, PostgreSQL
- `docs/` — architecture and deployment notes

## Important

This is not a one-click Windows VM provider. Windows access requires a reachable Windows machine with RDP enabled (or a VNC server). Codespaces is Linux-based and may stop when idle. Keep forwarded ports private. Never commit passwords or tokens.

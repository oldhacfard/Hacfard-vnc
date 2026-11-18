# Hacfard RemoteX Ultimate — Codespaces stack

The Codespaces devcontainer automatically installs dependencies and starts two remote-access paths:

1. **Direct VNC/noVNC:** XFCE + TigerVNC + websockify on private port 6080.
2. **Multi-protocol gateway:** Apache Guacamole + guacd + PostgreSQL + Nginx on private port 8080.

## Supported gateway protocols

The official Guacamole server image includes VNC, RDP, SSH, Telnet and Kubernetes protocol support. Actual access still requires a reachable host and valid credentials. RDP requires an RDP-enabled Windows host; SSH requires an SSH server; VNC requires a VNC server. Kubernetes access requires cluster credentials and network reachability.

Guacamole supports browser-based connection management, clipboard features and protocol-dependent file transfer/drive redirection. Features differ by protocol and remote server. This stack does not create Windows VMs or magically enable RDP on a host.

## Automatic setup

New Codespaces run `server/bootstrap.sh` after creation. Later starts run `server/auto-start.sh`. Docker-in-Docker is enabled in the devcontainer. For a pre-existing Codespace, use **Rebuild Container** once to apply the updated devcontainer configuration.

## Open the gateway

Open the PORTS tab and use the private forwarded port **8080**. The initial Guacamole database account is:

- Username: `guacadmin`
- Password: `guacadmin`

**Immediately change this password after first login.** Do not make port 8080 public. The database password is randomly generated in `server/.env`, ignored by Git, and persisted in the Codespace.

The direct VNC WebSocket endpoint remains on private port 6080 at `/websockify`. Its VNC password is stored at `~/.config/hacfard-remotex/vnc-password`.

## Useful commands

```bash
bash server/auto-start.sh
bash server/stop.sh
docker compose --env-file server/.env ps
docker compose --env-file server/.env logs -f guacamole guacd
```

## Security and deployment notes

- Keep forwarded ports 6080 and 8080 **Private**.
- guacd is not an authentication service; it is isolated on the internal Docker network.
- PostgreSQL and guacd are not published to the host.
- Use HTTPS/WSS, unique host credentials, MFA-capable auth extensions, and network restrictions for production.
- Codespaces is a development environment and may stop when idle. It is not a guaranteed always-on production host.
- The initial Guacamole admin password is a bootstrap credential; rotate it immediately.
- Do not commit `server/.env`, generated SQL, VNC passwords, host passwords, private keys, or tokens.

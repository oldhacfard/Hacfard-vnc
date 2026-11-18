# Hacfard RemoteX — Codespaces stack

The Codespaces devcontainer installs XFCE + TigerVNC + noVNC/websockify on private port 6080 and Apache Guacamole + guacd + PostgreSQL + Nginx on private port 8080.

## Open the gateway

Open private forwarded port 8080. Initial account: `guacadmin / guacadmin`. Change the password immediately and keep both ports private.

## Recovery and diagnostics

```bash
bash server/status.sh
bash server/recover.sh
docker compose --env-file server/.env logs --tail=100 guacamole
```

`recover.sh` is non-destructive: it recreates missing services, waits for PostgreSQL, restarts Guacamole and Nginx, tests the local gateway, and prints relevant logs. It does not delete the database volume or reset passwords.

## Protocol support

Guacamole/guacd supports VNC, RDP, SSH, Telnet and Kubernetes when the target host, network path and credentials exist. RDP requires an existing Windows host with RDP enabled. This repository does not yet provision a Windows 10 VM.

## Notes

New Codespaces run `server/bootstrap.sh`; later starts run `server/auto-start.sh`. Rebuild existing Codespaces after devcontainer changes. Codespaces may stop when idle. Never commit secrets, VNC passwords, private keys or tokens.

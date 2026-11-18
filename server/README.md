# Hacfard RemoteX — Codespaces stack

## Recovery

Run `bash server/status.sh` for application/API/database diagnostics. Run `bash server/recover.sh` for a non-destructive repair. Recovery checks PostgreSQL readiness and the Guacamole schema, applies the official generated schema only when the Guacamole user table is absent, then restarts the application and gateway.

**Recovery does not remove Docker volumes, drop databases, reset users, or erase stored connections.**

## Gateway

Open private forwarded port 8080. Initial account is `guacadmin / guacadmin`; change it immediately after successful login. Keep ports private.

## Limitations

Guacamole can connect to reachable VNC, RDP, SSH, Telnet and Kubernetes targets when configured. This repository does not yet provision a Windows 10 VM. Codespaces may stop when idle.

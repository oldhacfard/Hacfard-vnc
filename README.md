<div align="center">
  <img src="remotex/preview.svg" alt="Hacfard RemoteX custom workspace preview" width="100%">
  <h1>Hacfard RemoteX</h1>
  <p><strong>Custom remote desktop workspace · built by oldhacfard</strong></p>
  <p>VNC · RDP · SSH · Mobile-first · Custom HTML/CSS/JS</p>
</div>

---

## ✨ Overview

Hacfard RemoteX is a self-hostable remote-access workspace with its own custom browser interface. The frontend is not the noVNC UI: it is a purpose-built HTML/CSS/JavaScript workspace. Apache Guacamole and guacd handle the remote protocols behind the interface.

## Preview

The image above is a static UI preview. Open the live app from the private Codespaces port **8080** after setup.

## Features

- Custom black-and-white inspired responsive interface
- Gateway login and saved-connection list
- Guacamole WebSocket tunnel for supported remote protocols
- Fullscreen, connection state, session timer and touch-friendly layout
- Linux XFCE desktop through a configured VNC connection
- Windows guests through a configured RDP connection after Windows is installed and RDP is enabled
- No noVNC browser interface and no noVNC JavaScript client

## Quick start

1. Open this repository in GitHub Codespaces.
2. Wait for the devcontainer bootstrap to finish.
3. Keep port **8080** private. Port 6080 is no longer used.
4. Open the **RemoteX Custom UI** port **8080**.
5. Sign in with your Guacamole account.
6. Create or select a VNC/RDP connection in the gateway administration UI.

On first login, the initial Guacamole account may be `guacadmin / guacadmin`. Change the password immediately.

## Architecture

- `remotex/index.html` — custom interface and client-side session handling
- `remotex/preview.svg` — static visual preview used by this README
- `server/` — Linux desktop lifecycle, setup and recovery scripts
- `docker-compose.yml` — Guacamole, guacd, PostgreSQL and Nginx
- Nginx serves the custom UI and proxies only the Guacamole API/WebSocket tunnel

## Important notes

- The Guacamole JavaScript client library is loaded from a CDN; the UI requires network access to that CDN.
- Remote connections must already exist in Guacamole and have reachable target hosts.
- For the local XFCE VNC target, use a VNC connection reachable from `guacd`; do not expose port 5901 publicly.
- A Windows 10 VM is experimental. Codespaces may not expose nested virtualization; software emulation can be extremely slow.
- Keep all forwarded ports private. Never commit passwords, tokens, ISO files or VM disks.
- This project does not include a Windows license or Windows installation media.

## License

Use and modify this project for your own environment. Respect Microsoft Windows licensing and the licenses of bundled services.

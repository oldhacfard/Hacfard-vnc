# RemoteX server

The browser application is the custom HTML/CSS/JS workspace in `remotex/`. Nginx serves it on port 8080 and proxies Guacamole's `/api/` and `/websocket-tunnel` endpoints.

The server starts a private TigerVNC desktop on `127.0.0.1:5901`. Connect to it by creating a VNC connection in Guacamole with a host reachable from `guacd` (usually the Codespace host network arrangement must be checked; do not assume container localhost is the host). The browser never connects directly to VNC.

noVNC and websockify are no longer started or used as the browser UI. Keep the Guacamole gateway and all forwarded ports private.

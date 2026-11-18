# RemoteX Ultimate architecture

## Services

- Browser client: `remotex/index.html`
- Direct VNC transport: TigerVNC localhost display :1 -> websockify :6080 -> browser WebSocket
- Multi-protocol access: Nginx :8080 -> Guacamole webapp -> guacd
- Auth/configuration database: PostgreSQL, private Docker network only

## Protocol matrix

| Protocol | Gateway support | Remote requirement |
|---|---|---|
| VNC | Yes | VNC server reachable from guacd |
| RDP | Yes | Windows host with Remote Desktop enabled and reachable |
| SSH | Yes | SSH daemon and account/key |
| Telnet | Yes | Telnet endpoint; insecure, avoid outside isolated labs |
| Kubernetes | Yes | Cluster endpoint and valid credentials |
| SFTP | Through SSH file transfer | SSH/SFTP server and permissions |
| FTP | Not a native Guacamole desktop protocol | Use a separate secured file service |
| WebRTC | Not included in this stack | Separate media/signaling gateway |
| RustDesk | Not included | Separate RustDesk relay/server ecosystem |

## Security boundaries

- guacd is never published to the host; it is reachable only on the Compose network.
- PostgreSQL is never published to the host.
- Nginx publishes only the Guacamole web application on port 8080.
- Codespaces port visibility must remain Private.
- Bootstrap secrets are generated locally and ignored by Git.
- Do not expose VNC 5901 or guacd 4822 publicly.

## Performance

Guacamole is a protocol gateway, not a magic accelerator. Latency and image quality depend on host CPU/GPU, network RTT, codec support, remote protocol settings, and Codespaces resources. Use RDP/VNC settings appropriate to the remote host and prefer a geographically close host. High-frame-rate gaming/3D streaming needs a specialized low-latency media solution such as a properly deployed WebRTC-based remote desktop stack.

## Scope and honest limitations

This repository configures the Codespace's Linux desktop and gateway. It does not provision Windows licenses, nested hypervisors, remote hosts, firewall rules on external machines, or user accounts on those machines. It does not guarantee 24/7 uptime.

# RemoteX server

The browser application is the custom HTML/CSS/JS workspace in remotex/. Nginx serves it on private port 8080 and proxies Guacamole API requests, client assets, and the WebSocket tunnel.

## Linux desktop

The Codespace runs an XFCE desktop through TigerVNC on port 5901. The VNC server uses a generated password stored in ~/.config/hacfard-remotex/vnc-password. Guacamole runs in Docker and reaches the Codespace host through host.docker.internal:5901. Create the Linux XFCE VNC connection in the RemoteX UI.

## Windows 10 guest

Windows is an optional experimental QEMU guest. Upload your own licensed ISO to ~/Windows10.iso, then run bash server/windows10-start.sh. First boot creates a QCOW2 disk and starts the installer. The generated VNC password is stored in ~/.config/hacfard-remotex/windows10-vnc-password. Create a Windows 10 Console VNC connection in the RemoteX UI. After installing Windows, enable Remote Desktop and create a Windows 10 Desktop RDP connection.

QEMU uses KVM when available and TCG otherwise. TCG is slow. The Windows VM disk lives under ~/.local/share/hacfard-remotex/windows10 and is never stored in Git.

## Security

Keep forwarded port 8080 private. Do not forward ports 5901, 5902, or 3389 publicly. noVNC and websockify are not used as the browser UI.

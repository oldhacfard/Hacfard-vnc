# Codespaces server setup

1. Rebuild the Codespace container after adding `.devcontainer/devcontainer.json`, or run `bash server/install.sh` in an existing Codespace.
2. Start with `bash server/start.sh` and choose a strong VNC password when prompted.
3. Open the PORTS tab and verify port 6080 is forwarded with **Private** visibility.
4. Copy the HTTPS forwarded URL for port 6080 and add `/websockify` to form the WebSocket endpoint.
5. Open the RemoteX client over HTTPS and enter the endpoint. Enter the VNC password when requested.

The VNC server listens only on localhost:5901. websockify exposes the WebSocket bridge on 6080. Keep the Codespaces port private.

Codespaces is a Linux development environment. This recipe creates an XFCE Linux desktop, not a Windows 10 virtual machine, and does not provide guaranteed 24/7 hosting.

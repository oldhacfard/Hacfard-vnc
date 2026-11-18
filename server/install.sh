#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "[RemoteX] Install failed at line $LINENO. See the package-manager output above." >&2' ERR

as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then "$@"
  elif command -v sudo >/dev/null 2>&1; then sudo "$@"
  else
    echo "[RemoteX] Need root privileges. Rebuild the Ubuntu devcontainer; do not run apk/apt manually in a restricted container." >&2
    exit 1
  fi
}

echo "[RemoteX] Detecting Linux distribution..."
if [[ -r /etc/os-release ]]; then . /etc/os-release; else ID=unknown; fi
echo "[RemoteX] Distribution: ${PRETTY_NAME:-$ID}"

case "${ID:-unknown}" in
  ubuntu|debian)
    as_root apt-get update
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      xfce4 xfce4-terminal dbus-x11 tigervnc-standalone-server tigervnc-tools \
      novnc websockify ca-certificates curl procps python3
    ;;
  alpine)
    # Alpine support is best-effort. The recommended Codespaces image remains Ubuntu.
    as_root apk add --no-cache bash xfce4 xfce4-terminal dbus dbus-x11 \
      tigervnc novnc py3-websockify ca-certificates curl procps python3
    ;;
  *)
    echo "[RemoteX] Unsupported distribution: ${ID:-unknown}. Use the repository's Ubuntu devcontainer and rebuild it." >&2
    exit 1
    ;;
esac

for bin in python3; do
  command -v "$bin" >/dev/null 2>&1 || { echo "[RemoteX] Required command missing: $bin" >&2; exit 1; }
done
if ! command -v vncserver >/dev/null 2>&1 && command -v tigervncserver >/dev/null 2>&1; then
  echo "[RemoteX] Found tigervncserver; creating vncserver compatibility link."
  as_root ln -sf "$(command -v tigervncserver)" /usr/local/bin/vncserver
fi
command -v vncserver >/dev/null 2>&1 || { echo "[RemoteX] TigerVNC server executable was not installed." >&2; exit 1; }
command -v websockify >/dev/null 2>&1 || { echo "[RemoteX] websockify executable was not installed." >&2; exit 1; }
mkdir -p "$HOME/.vnc" "$HOME/.config/hacfard-remotex" "$HOME/.local/state/hacfard-remotex"
chmod 700 "$HOME/.vnc" "$HOME/.config/hacfard-remotex"
echo "[RemoteX] Desktop/VNC dependencies are ready."

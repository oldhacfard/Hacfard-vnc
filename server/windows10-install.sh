#!/usr/bin/env bash
set -Eeuo pipefail
if [[ "$(id -u)" -eq 0 ]]; then SUDO=""; else SUDO="sudo"; fi
if ! command -v apt-get >/dev/null 2>&1; then echo "[RemoteX VM] Ubuntu/Debian host required for this installer." >&2; exit 1; fi
$SUDO apt-get update
$SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-system-x86 qemu-utils ovmf socat
mkdir -p "$HOME/.local/share/hacfard-remotex/windows10" "$HOME/.local/state/hacfard-remotex"
chmod 700 "$HOME/.local/share/hacfard-remotex/windows10"
echo "[RemoteX VM] QEMU installed."
if [[ -e /dev/kvm && -r /dev/kvm && -w /dev/kvm ]]; then
 echo "[RemoteX VM] KVM acceleration is available."
else
 echo "[RemoteX VM] KVM unavailable; QEMU TCG software emulation will be used (very slow)."
fi
echo "[RemoteX VM] Put a licensed Windows 10 ISO at: $HOME/Windows10.iso"

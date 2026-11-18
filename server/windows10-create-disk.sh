#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$HOME/.local/share/hacfard-remotex/windows10"
mkdir -p "$DIR"
DISK="$DIR/windows10.qcow2"
SIZE="${VM_DISK_SIZE:-64G}"
if [[ -e "$DISK" ]]; then echo "[RemoteX VM] Existing disk preserved: $DISK"; else qemu-img create -f qcow2 "$DISK" "$SIZE"; fi
echo "[RemoteX VM] Disk ready: $DISK"
echo "[RemoteX VM] Place Windows ISO at $HOME/Windows10.iso before first boot."

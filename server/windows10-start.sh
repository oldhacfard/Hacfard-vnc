#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$HOME/.local/share/hacfard-remotex/windows10"
ISO="${WINDOWS_ISO:-$HOME/Windows10.iso}"
DISK="$DIR/windows10.qcow2"
LOG="$HOME/.local/state/hacfard-remotex/windows10-qemu.log"
mkdir -p "$DIR" "$(dirname "$LOG")"
command -v qemu-system-x86_64 >/dev/null 2>&1 || { echo "Run bash server/windows10-install.sh first." >&2; exit 1; }
[[ -s "$ISO" ]] || { echo "Windows ISO not found: $ISO. Supply your own licensed ISO." >&2; exit 1; }
[[ -s "$DISK" ]] || bash server/windows10-create-disk.sh
if pgrep -af '[q]emu-system-x86_64.*windows10.qcow2' >/dev/null; then echo "[RemoteX VM] Windows VM already appears to be running."; exit 0; fi
ACCEL=tcg
if [[ -e /dev/kvm && -r /dev/kvm && -w /dev/kvm ]]; then ACCEL=kvm; fi
echo "[RemoteX VM] Starting Windows 10 with accelerator: $ACCEL"
echo "[RemoteX VM] VNC console: host.docker.internal:5902 (not forwarded publicly)"
nohup qemu-system-x86_64 \
  -name Hacfard-Windows10 \
  -machine q35,accel="$ACCEL" \
  -cpu max -smp "${VM_CPUS:-2}" -m "${VM_MEMORY:-4096}" \
  -drive "file=$DISK,if=virtio,format=qcow2" \
  -cdrom "$ISO" -boot order=d \
  -vga std -display none -vnc 0.0.0.0:2 \
  -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::3389-:3389 \
  -rtc base=localtime \
  -monitor unix:"$DIR/monitor.sock",server=on,wait=off \
  -pidfile "$DIR/qemu.pid" \
  >>"$LOG" 2>&1 &
echo $! > "$DIR/launcher.pid"
sleep 3
if kill -0 "$(cat "$DIR/launcher.pid")" 2>/dev/null; then echo "[RemoteX VM] QEMU process started. Log: $LOG"; else echo "[RemoteX VM] QEMU failed. Recent log:"; tail -n 80 "$LOG"; exit 1; fi

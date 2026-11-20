#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$HOME/.local/share/hacfard-remotex/windows10"
CONFIG="$HOME/.config/hacfard-remotex"
ISO="${WINDOWS_ISO:-$HOME/Windows10.iso}"
DISK="$DIR/windows10.qcow2"
LOG="$HOME/.local/state/hacfard-remotex/windows10-qemu.log"
mkdir -p "$DIR" "$CONFIG" "$(dirname "$LOG")"
chmod 700 "$DIR" "$CONFIG"
command -v qemu-system-x86_64 >/dev/null 2>&1 || { echo "Run bash server/windows10-install.sh first." >&2; exit 1; }
[[ -s "$ISO" ]] || { echo "Windows ISO not found: $ISO. Supply your own licensed ISO." >&2; exit 1; }
BOOT=c
if [[ ! -s "$DISK" ]]; then
  bash server/windows10-create-disk.sh
  BOOT=d
fi
if pgrep -af '[q]emu-system-x86_64.*windows10.qcow2' >/dev/null; then echo "[RemoteX VM] Windows VM already appears to be running."; exit 0; fi
ACCEL=tcg
if [[ -e /dev/kvm && -r /dev/kvm && -w /dev/kvm ]]; then ACCEL=kvm; fi
if [[ ! -s "$CONFIG/windows10-vnc-password" ]]; then
  python3 -c 'import secrets,string; print("".join(secrets.choice(string.ascii_letters+string.digits) for _ in range(8)))' > "$CONFIG/windows10-vnc-password"
  chmod 600 "$CONFIG/windows10-vnc-password"
fi
VNC_PASS="$(cat "$CONFIG/windows10-vnc-password")"
echo "[RemoteX VM] Starting Windows 10 (accelerator: $ACCEL, boot: $BOOT)"
nohup qemu-system-x86_64 \
  -name Hacfard-Windows10 \
  -machine q35,accel="$ACCEL" \
  -cpu max -smp "${VM_CPUS:-2}" -m "${VM_MEMORY:-4096}" \
  -drive "file=$DISK,if=virtio,format=qcow2" \
  -cdrom "$ISO" -boot order="$BOOT" \
  -vga std -display none -vnc 0.0.0.0:2,password=on \
  -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::3389-:3389 \
  -rtc base=localtime \
  -monitor unix:"$DIR/monitor.sock",server=on,wait=off \
  -pidfile "$DIR/qemu.pid" \
  >>"$LOG" 2>&1 &
echo $! > "$DIR/launcher.pid"
sleep 3
if ! kill -0 "$(cat "$DIR/launcher.pid")" 2>/dev/null; then echo "[RemoteX VM] QEMU failed:"; tail -n 80 "$LOG"; exit 1; fi
if command -v socat >/dev/null 2>&1; then
  printf 'change vnc password %s\n' "$VNC_PASS" | socat - UNIX-CONNECT:"$DIR/monitor.sock" >/dev/null
fi
unset VNC_PASS
echo "[RemoteX VM] QEMU started. Console: host.docker.internal:5902"
echo "[RemoteX VM] VNC password is stored privately in $CONFIG/windows10-vnc-password"
echo "[RemoteX VM] Password reveal: cat $CONFIG/windows10-vnc-password"
echo "[RemoteX VM] QEMU log: $LOG"

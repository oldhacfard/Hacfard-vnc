#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$HOME/.local/share/hacfard-remotex/windows10"
PID="$DIR/launcher.pid"
echo "=== Windows 10 VM status ==="
if [[ -s "$PID" ]] && kill -0 "$(cat "$PID")" 2>/dev/null; then
  echo "QEMU process: running (PID $(cat "$PID"))"
else
  echo "QEMU process: stopped"
fi
if [[ -e /dev/kvm && -r /dev/kvm && -w /dev/kvm ]]; then echo "Acceleration: KVM available"; else echo "Acceleration: TCG software emulation"; fi
[[ -s "$DIR/windows10.qcow2" ]] && ls -lh "$DIR/windows10.qcow2" || echo "Disk: not created"
[[ -s "$HOME/.local/state/hacfard-remotex/windows10-qemu.log" ]] && tail -n 25 "$HOME/.local/state/hacfard-remotex/windows10-qemu.log" || true

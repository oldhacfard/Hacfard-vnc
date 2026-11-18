# Windows 10 VM test (experimental)

This is an experimental QEMU guest inside Codespaces, not a guaranteed cloud Windows host. Codespaces may deny nested virtualization, CPU/RAM may be constrained, and TCG is extremely slow. The QEMU documentation confirms TCG is software CPU emulation and KVM is a separate Linux accelerator.

## Setup

1. Run `bash server/windows10-install.sh`.
2. Supply your own licensed Windows 10 ISO at `~/Windows10.iso`.
3. Run `bash server/windows10-create-disk.sh`.
4. Run `bash server/windows10-start.sh`.

The VM disk is stored outside the repository at `~/.local/share/hacfard-remotex/windows10/windows10.qcow2`. The default virtual disk is 64 GB, memory 4 GB and 2 vCPUs. Change `VM_MEMORY`, `VM_CPUS`, or `VM_DISK_SIZE` before creating/starting if needed.

The installation console is QEMU VNC on port 5902, intended for a Guacamole VNC connection to `host.docker.internal:5902`. Do not forward port 5902 publicly. This experimental console currently has no VNC password; only use it inside a trusted private Codespaces environment and do not expose it. After Windows installation, enable Remote Desktop in Windows and use Guacamole RDP to `host.docker.internal:3389` (credentials and Windows firewall must be configured).

Stop with `bash server/windows10-stop.sh`. The stop script requests a graceful guest shutdown; it does not delete the disk.

No Windows ISO, license, Windows VM boot, or RDP session is included or verified by this commit. If KVM is unavailable, QEMU uses TCG which may be too slow for practical Windows use.

# Windows 10 VM (experimental)

RemoteX runs Windows 10 as a QEMU guest inside the Codespace. This is nested virtualization, not a dedicated Windows cloud VM. GitHub Codespaces may not expose /dev/kvm; without KVM, QEMU uses TCG software emulation and Windows can be extremely slow.

## Install and boot

1. Upload your own licensed Windows 10 ISO to the Codespace home directory as ~/Windows10.iso.
2. Run bash server/windows10-start.sh. QEMU is installed by the main bootstrap; alternatively run bash server/windows10-install.sh.
3. The first boot creates a 64 GB QCOW2 disk using an IDE-compatible virtual controller and boots the ISO for installation. If installation needs to resume from the ISO after the disk has been created, run WINDOWS_BOOT_ORDER=d bash server/windows10-start.sh.
4. Open the RemoteX UI and sign in. The console password is shown by cat ~/.config/hacfard-remotex/windows10-vnc-password.
5. Create a Windows 10 kurulum ekranı · VNC connection. Complete Windows Setup.
6. Later starts boot from the disk. Use Windows 10 Pro or Enterprise for incoming RDP (Windows Home does not include the built-in RDP host). Enable Remote Desktop, configure a strong account password and allow RDP through Windows Firewall.
7. Create a Windows 10 masaüstü · RDP connection using the Windows account credentials.

## Resources and storage

Defaults: 2 vCPUs, 4 GB RAM, 64 GB dynamically allocated QCOW2 disk. Set VM_CPUS, VM_MEMORY, and VM_DISK_SIZE before first start. The disk is stored outside Git in ~/.local/share/hacfard-remotex/windows10/windows10.qcow2.

## Security and limitations

- Keep forwarded port 8080 private. Do not forward 5901, 5902, or 3389 publicly.
- QEMU VNC uses a generated password stored with mode 0600.
- The VM disk and ISO are not committed to the repository.
- Codespaces may not provide nested KVM; TCG can be too slow for practical Windows use.
- No Windows installation, license, KVM availability, or RDP login is guaranteed by this project.
- Windows 10 standard support ended on 14 October 2025; use a supported, licensed OS where possible.

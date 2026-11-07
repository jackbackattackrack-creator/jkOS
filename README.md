# jkOS

Arch-based live ISO with **KDE Plasma** and a **Calamares online installer**.

The live session is a working Plasma desktop. Installation does **not** clone that live system. Calamares partitions the disk, then `pacstrap`s a fresh jkOS (base + Plasma) from Arch Linux mirrors.

## What you get

- Live boot: SDDM autologin as user `live` (password `live`)
- Desktop installer: **Install jkOS**
- Installed system: Arch repos, `ID=jkos`, GRUB, NetworkManager, SDDM, Plasma
- Online-only install: internet is required on the welcome page

## Build (needs Linux)

This tree is an [archiso](https://wiki.archlinux.org/title/Archiso) profile. **mkarchiso must run on Arch Linux** (native, VM, or WSL2 with Arch). It cannot build on Windows.

```bash
sudo pacman -S --needed archiso
sudo ./build.sh
```

Calamares is not in the official Arch repos. `build.sh` builds it (and `ckbcomp`) from the AUR into `localrepo/` first. The live ISO is about 2 GB; the installed system then downloads a full Plasma set from the internet.

The ISO lands in `out/`. Flash it with `dd`, [Ventoy](https://www.ventoy.net/), or your usual USB tool.

Approximate live image size is a few gigabytes (kernel + Plasma + Calamares). The installed system downloads more during setup.

## Try in a VM

Use at least 2 CPU cores, 4 GB RAM, and a writable virtual disk (20 GB+). Enable EFI if you want the UEFI boot path. Give the VM a network connection before starting the installer.

QEMU example:

```bash
qemu-system-x86_64 \
  -enable-kvm -m 4096 -smp 4 \
  -cdrom out/jkos-*.iso \
  -drive file=jkos-disk.qcow2,if=virtio \
  -boot d
```

## Layout

| Path | Role |
| --- | --- |
| `profiledef.sh` | ISO name, boot modes, permissions |
| `packages.x86_64` | Packages in the **live** image |
| `airootfs/` | Overlay: Plasma, SDDM, Calamares branding |
| `airootfs/usr/local/bin/jkos-online-install` | Online `pacstrap` list (base + Plasma) |
| `airootfs/etc/calamares/` | Installer sequence and jkOS branding |

Edit `jkos-online-install` to change what the installed system gets. Edit `packages.x86_64` to change the live session.

## Notes

- Live session uses Plasma **X11** so VirtualBox/QEMU without GPU passthrough still work. The installed system prefers Plasma Wayland.
- Root on the live ISO has an empty password (same idea as the official Arch ISO) if you need a TTY.
- jkOS tracks Arch; you still update with `pacman -Syu`.

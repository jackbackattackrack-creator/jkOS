#!/usr/bin/env bash
# Build the jkOS live ISO. Must run on Arch Linux (or Arch WSL) as root.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="${ROOT}/out"
WORK="${ROOT}/work"
A="${ROOT}/airootfs"

if [[ ${EUID} -ne 0 ]]; then
  echo "jkOS: re-run as root (needed for mkarchiso loop mounts)." >&2
  exit 1
fi

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "jkOS: install archiso first: pacman -S --needed archiso" >&2
  exit 1
fi

# Calamares is AUR-only; build it into a file:// repo for mkarchiso.
bash "${ROOT}/scripts/build-local-repo.sh"
sed -i "s|^Server = file://.*|Server = file://${ROOT}/localrepo|" "${ROOT}/pacman.conf"

chmod 755 "${A}/usr/local/bin/"jkos-*
chmod 440 "${A}/etc/sudoers.d/jkos"

enable_unit() {
  local wants_dir="$1"
  local unit="$2"
  local target="$3"
  mkdir -p "${wants_dir}"
  ln -sfn "${target}" "${wants_dir}/${unit}"
}

# Graphical live session + installer services
mkdir -p "${A}/etc/systemd/system"
ln -sfn /usr/lib/systemd/system/graphical.target "${A}/etc/systemd/system/default.target"
ln -sfn /usr/lib/systemd/system/sddm.service "${A}/etc/systemd/system/display-manager.service"

enable_unit "${A}/etc/systemd/system/multi-user.target.wants" pacman-init.service /etc/systemd/system/pacman-init.service
enable_unit "${A}/etc/systemd/system/multi-user.target.wants" jkos-live-user.service /etc/systemd/system/jkos-live-user.service
enable_unit "${A}/etc/systemd/system/multi-user.target.wants" jkos-reflector.service /etc/systemd/system/jkos-reflector.service
enable_unit "${A}/etc/systemd/system/multi-user.target.wants" NetworkManager.service /usr/lib/systemd/system/NetworkManager.service
enable_unit "${A}/etc/systemd/system/multi-user.target.wants" systemd-resolved.service /usr/lib/systemd/system/systemd-resolved.service
enable_unit "${A}/etc/systemd/system/multi-user.target.wants" bluetooth.service /usr/lib/systemd/system/bluetooth.service
enable_unit "${A}/etc/systemd/system/graphical.target.wants" sddm.service /usr/lib/systemd/system/sddm.service
enable_unit "${A}/etc/systemd/system/network-online.target.wants" NetworkManager-wait-online.service /usr/lib/systemd/system/NetworkManager-wait-online.service
enable_unit "${A}/etc/systemd/system/sysinit.target.wants" systemd-timesyncd.service /usr/lib/systemd/system/systemd-timesyncd.service

mkdir -p "${OUT}"
rm -rf "${WORK}"
mkarchiso -v -w "${WORK}" -o "${OUT}" "${ROOT}"
echo
echo "ISO written to ${OUT}"
ls -lh "${OUT}"/*.iso

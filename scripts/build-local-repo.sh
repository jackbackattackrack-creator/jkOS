#!/usr/bin/env bash
# Build AUR packages that the live ISO needs (calamares is not in official repos).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCALREPO="${ROOT}/localrepo"
WORKDIR="/var/tmp/jkos-aur"
BUILD_USER="jkosbuilder"

mkdir -p "${LOCALREPO}" "${WORKDIR}"
pacman -S --needed --noconfirm base-devel git sudo

if ! id "${BUILD_USER}" >/dev/null 2>&1; then
  useradd -m -G wheel "${BUILD_USER}"
fi
echo "${BUILD_USER} ALL=(ALL:ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${BUILD_USER}"
chmod 440 "/etc/sudoers.d/${BUILD_USER}"

build_aur() {
  local pkg="$1"
  if compgen -G "${LOCALREPO}/${pkg}-*.pkg.tar.*" >/dev/null; then
    echo "jkOS: ${pkg} already in localrepo"
    return 0
  fi
  rm -rf "${WORKDIR}/${pkg}"
  git clone --depth 1 "https://aur.archlinux.org/${pkg}.git" "${WORKDIR}/${pkg}"
  chown -R "${BUILD_USER}:${BUILD_USER}" "${WORKDIR}/${pkg}"
  su -s /bin/bash "${BUILD_USER}" -c "cd '${WORKDIR}/${pkg}' && makepkg -s --noconfirm --needed"
  cp -v "${WORKDIR}/${pkg}"/*.pkg.tar.zst "${LOCALREPO}/"
}

build_aur ckbcomp
build_aur calamares

rm -f "${LOCALREPO}/jkos".db* "${LOCALREPO}/jkos".files*
repo-add "${LOCALREPO}/jkos.db.tar.zst" "${LOCALREPO}"/*.pkg.tar.zst
chown -R root:root "${LOCALREPO}"
echo "jkOS: local repo ready at ${LOCALREPO}"

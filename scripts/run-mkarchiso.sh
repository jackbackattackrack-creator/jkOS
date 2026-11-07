#!/usr/bin/env bash
set -euo pipefail
ROOT=/root/jkOS
A="${ROOT}/airootfs"

chmod 755 "${A}/usr/local/bin/"jkos-*
chmod 440 "${A}/etc/sudoers.d/jkos"

enable_unit() {
  mkdir -p "$1"
  ln -sfn "$3" "$1/$2"
}

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

mkdir -p "${ROOT}/out"
rm -rf "${ROOT}/work"
exec mkarchiso -v -w "${ROOT}/work" -o "${ROOT}/out" "${ROOT}"

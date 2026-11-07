#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="jkos"
iso_label="JKOS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="jkOS"
iso_application="jkOS Live/Install DVD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="jkos"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/jkos"]="0:0:440"
  ["/root"]="0:0:750"
  ["/usr/local/bin/jkos-online-install"]="0:0:755"
  ["/usr/local/bin/jkos-setup-live-user"]="0:0:755"
  ["/usr/local/bin/jkos-reflector"]="0:0:755"
)

#!/usr/bin/env bash
set -euo pipefail

SRC="/mnt/c/Users/shurda/Projects/jkOS"
DST="/root/jkOS"

rm -rf "${DST}"
mkdir -p "${DST}"
cp -a "${SRC}/." "${DST}/"
cd "${DST}"

find . -type f ! -path "./.git/*" ! -name "*.png" -exec dos2unix -q {} +
chmod 755 build.sh profiledef.sh airootfs/usr/local/bin/jkos-online-install \
  airootfs/usr/local/bin/jkos-setup-live-user airootfs/usr/local/bin/jkos-reflector

exec ./build.sh

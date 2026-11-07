#!/bin/bash
for p in kpmcore yaml-cpp ckbcomp python-jsonschema extra-cmake-modules qt6-tools kconfig kcoreaddons ki18n kiconthemes kio kservice kwidgetsaddons solid polkit-qt6 boost python cmake ninja; do
  if pacman -Si "$p" >/dev/null 2>&1; then
    echo "OK:$p"
  else
    echo "MISSING:$p"
  fi
done

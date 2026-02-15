#!/bin/bash -e

# Add Hat Labs GPG key for HALPI2 hardware packages
curl -fsSL https://apt.hatlabs.fi/hat-labs-apt-key.asc | gpg --dearmor > "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/hatlabs.gpg"

# Add HALPI2 hardware packages repository (hatlabs component)
echo "deb https://apt.hatlabs.fi trixie-stable hatlabs" >> "${ROOTFS_DIR}/etc/apt/sources.list.d/hatlabs.list"
on_chroot << EOF
apt-get update
EOF

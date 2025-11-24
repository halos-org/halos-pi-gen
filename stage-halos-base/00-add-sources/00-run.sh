#!/bin/bash -e

# Add HaLOS packages repository (trixie-stable main component)
# GPG key already added by stage-common
echo "deb https://apt.hatlabs.fi trixie-stable main" >> "${ROOTFS_DIR}/etc/apt/sources.list.d/hatlabs.list"
on_chroot << EOF
apt-get update
EOF

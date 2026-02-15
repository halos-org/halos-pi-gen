#!/bin/bash -e

# Add HaLOS GPG key for apt.halos.fi repository
# Sources will be added by stage-halos-base
curl -fsSL https://apt.halos.fi/halos-apt-key.asc | gpg --dearmor > "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/halos.gpg"

#!/bin/bash -e

# Add Hat Labs GPG key for apt.hatlabs.fi repository
# Sources will be added by stage-halos-base (main) and/or stage-halpi2-common (hatlabs)
curl -fsSL https://apt.hatlabs.fi/hat-labs-apt-key.asc | gpg --dearmor > "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/hatlabs.gpg"

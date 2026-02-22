#!/bin/bash -e

# HALPI2 only runs on BCM2712 hardware, which uses the 2712 kernel.
# Remove the unused generic arm64 (v8) kernel and headers.
on_chroot << EOF
apt-get purge -y linux-image-rpi-v8 linux-headers-rpi-v8
EOF

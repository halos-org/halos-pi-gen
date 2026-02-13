#!/bin/bash -e

install -d "${ROOTFS_DIR}/usr/libexec/halos"

install -m 755 files/configure-gnss-marine.sh \
    "${ROOTFS_DIR}/usr/libexec/halos/configure-gnss-marine.sh"

install -m 644 files/configure-gnss-marine.service \
    "${ROOTFS_DIR}/etc/systemd/system/configure-gnss-marine.service"

on_chroot << EOF
systemctl enable configure-gnss-marine.service
EOF

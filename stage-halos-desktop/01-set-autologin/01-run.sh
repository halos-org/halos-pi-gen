#!/bin/bash -e

# Enable graphical desktop autologin for the first user.
#
# Two things are needed:
#
# 1. Set autologin-user in lightdm.conf (build-time).
#    The RPi lightdm package normally does this during installation, but we
#    set it explicitly in case the default changes.
#
# 2. Create /var/lib/userconf-pi/autologin marker file.
#    On first boot, userconf-pi's cancel-rename script checks for this file
#    to decide between B3 (desktop login) and B4 (desktop autologin). Without
#    it, cancel-rename resets lightdm to require a login, undoing (1).
#    The marker is normally created by rename-user, but that only runs when
#    DISABLE_FIRST_BOOT_USER_RENAME=0.

sed -i "s/^#autologin-user=.*/autologin-user=${FIRST_USER_NAME}/" \
    "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"

grep -q "^autologin-user=${FIRST_USER_NAME}" "${ROOTFS_DIR}/etc/lightdm/lightdm.conf" || {
    echo "ERROR: Failed to set autologin-user in lightdm.conf" >&2
    exit 1
}

mkdir -p "${ROOTFS_DIR}/var/lib/userconf-pi"
touch "${ROOTFS_DIR}/var/lib/userconf-pi/autologin"

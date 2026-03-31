#!/bin/bash -e

# Enable graphical desktop autologin for the first user.
# We configure lightdm directly rather than using raspi-config because
# raspi-config's do_autologin requires $USER to be set, which it isn't
# in the pi-gen chroot environment.

sed -i "s/^#autologin-user=.*/autologin-user=${FIRST_USER_NAME}/" \
    "${ROOTFS_DIR}/etc/lightdm/lightdm.conf"

# Fail the build if the substitution didn't take effect
grep -q "^autologin-user=${FIRST_USER_NAME}" "${ROOTFS_DIR}/etc/lightdm/lightdm.conf" || {
    echo "ERROR: Failed to set autologin-user in lightdm.conf" >&2
    exit 1
}

#!/bin/bash -e

# Enable UART0 in boot config for MAX-M8Q GNSS HAT
cat files/config.txt.part >>"${ROOTFS_DIR}/boot/firmware/config.txt"

# Register HALPI2 GPS device for gpsd setup (consumed by stage-halos-marine)
mkdir -p "${WORK_DIR}/gpsd-devices"
echo "/dev/ttyAMA0" > "${WORK_DIR}/gpsd-devices/halpi2"

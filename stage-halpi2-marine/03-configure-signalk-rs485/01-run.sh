#!/bin/bash -e

# Install RS-485 NMEA 0183 provider snippet for Signal K
# The signalk-server prestart.sh reads snippets from this directory
# when generating settings.json on first boot
install -d "${ROOTFS_DIR}/etc/halos/signalk-providers.d"
install -m 644 files/halpi2-rs485.json "${ROOTFS_DIR}/etc/halos/signalk-providers.d/halpi2-rs485.json"

#!/bin/bash -e

# Add HALPI2 NMEA 2000 (CAN bus) provider to Signal K settings.json.
# The file is installed by marine-signalk-server-container (via stage-halos-marine).
# uniqueNumber is set to 0 here and randomized on first boot by a systemd service.

SETTINGS="${ROOTFS_DIR}/var/lib/container-apps/marine-signalk-server-container/data/data/settings.json"

# Add provider only if not already present (idempotent)
if ! jq -e '.pipedProviders[] | select(.id == "halpi2-nmea2000")' "${SETTINGS}" >/dev/null 2>&1; then
  jq '.pipedProviders += [{
    "id": "halpi2-nmea2000",
    "pipeElements": [
      {
        "type": "providers/simple",
        "options": {
          "logging": false,
          "type": "NMEA2000",
          "subOptions": {
            "type": "canbus-canboatjs",
            "interface": "can0",
            "uniqueNumber": 0
          }
        }
      }
    ],
    "enabled": true
  }]' "${SETTINGS}" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "${SETTINGS}"
fi

# Install first-boot script to randomize the NMEA 2000 unique number
install -m 755 files/set-signalk-can-unique-number.sh \
  "${ROOTFS_DIR}/usr/libexec/halos/set-signalk-can-unique-number.sh"

# Install and enable the systemd service
install -m 644 files/set-signalk-can-unique-number.service \
  "${ROOTFS_DIR}/etc/systemd/system/set-signalk-can-unique-number.service"

on_chroot <<EOF
systemctl enable set-signalk-can-unique-number
EOF

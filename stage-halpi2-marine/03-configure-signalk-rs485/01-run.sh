#!/bin/bash -e

# Add HALPI2 RS-485 NMEA 0183 provider to Signal K settings.json.
# The file is installed by marine-signalk-server-container (via stage-halos-marine).

SETTINGS="${ROOTFS_DIR}/var/lib/container-apps/marine-signalk-server-container/data/data/settings.json"

jq '.pipedProviders += [{
  "id": "halpi2-rs485",
  "pipeElements": [
    {
      "type": "providers/serialport",
      "options": {
        "device": "/dev/ttyAMA4",
        "baudrate": 4800,
        "toStdout": "nmea0183out"
      }
    },
    {
      "type": "providers/nmea0183-signalk"
    }
  ],
  "enabled": true
}]' "${SETTINGS}" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "${SETTINGS}"

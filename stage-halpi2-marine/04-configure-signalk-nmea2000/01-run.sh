#!/bin/bash -e

# Add HALPI2 NMEA 2000 (CAN bus) provider to Signal K settings.json.
# The file is installed by marine-signalk-server-container (via stage-halos-marine).
# uniqueNumber is set to 0 here and randomized on first boot by a systemd service.

SETTINGS="${ROOTFS_DIR}/var/lib/container-apps/marine-signalk-server-container/data/data/settings.json"

python3 -c "
import json, sys

with open(sys.argv[1]) as f:
    settings = json.load(f)

provider = {
    'id': 'halpi2-nmea2000',
    'pipeElements': [
        {
            'type': 'providers/simple',
            'options': {
                'logging': False,
                'type': 'NMEA2000',
                'subOptions': {
                    'type': 'canbus-canboatjs',
                    'interface': 'can0',
                    'uniqueNumber': 0
                }
            }
        }
    ],
    'enabled': True
}

if not any(p.get('id') == 'halpi2-nmea2000' for p in settings['pipedProviders']):
    settings['pipedProviders'].append(provider)

with open(sys.argv[1], 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
" "${SETTINGS}"

# Install first-boot script to randomize the NMEA 2000 unique number
install -m 755 files/set-signalk-can-unique-number.sh \
  "${ROOTFS_DIR}/usr/libexec/halos/set-signalk-can-unique-number.sh"

# Install and enable the systemd service
install -m 644 files/set-signalk-can-unique-number.service \
  "${ROOTFS_DIR}/etc/systemd/system/set-signalk-can-unique-number.service"

on_chroot <<EOF
systemctl enable set-signalk-can-unique-number
EOF

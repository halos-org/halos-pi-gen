#!/bin/bash -e

# Randomize the NMEA 2000 unique number in Signal K settings.json.
# Runs once on first boot, then self-destructs.
#
# Each NMEA 2000 device needs a unique address number to avoid bus conflicts.
# The number is generated at runtime (not build time) so that SD cards cloned
# from the same image each get a distinct value.

SETTINGS="/var/lib/container-apps/marine-signalk-server-container/data/data/settings.json"

# NMEA 2000 unique number is 21 bits (0–2097151) per ISO 11783-5
UNIQUENUMBER=$(shuf -i 0-2097151 -n 1)

python3 -c "
import json, sys

unique = int(sys.argv[1])
settings_path = sys.argv[2]

with open(settings_path) as f:
    settings = json.load(f)

for provider in settings.get('pipedProviders', []):
    if provider.get('id') == 'halpi2-nmea2000':
        provider['pipeElements'][0]['options']['subOptions']['uniqueNumber'] = unique
        break

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
" "${UNIQUENUMBER}" "${SETTINGS}"

echo "NMEA 2000 uniqueNumber set to ${UNIQUENUMBER}" | systemd-cat -t set-can-unique

# Self-destruct: disable service first, then remove files
systemctl disable set-signalk-can-unique-number
rm -f /etc/systemd/system/set-signalk-can-unique-number.service
rm -f /usr/libexec/halos/set-signalk-can-unique-number.sh

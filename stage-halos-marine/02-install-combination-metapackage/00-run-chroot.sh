#!/bin/bash -e

# Install the appropriate desktop/headless marine combination metapackage.
# stage-halos-desktop or stage-halos-headless runs before this stage,
# so we can check which variant is installed.

if dpkg -l halos-desktop 2>/dev/null | grep -q '^ii'; then
    apt-get install -y halos-desktop-marine
else
    apt-get install -y halos-headless-marine
fi

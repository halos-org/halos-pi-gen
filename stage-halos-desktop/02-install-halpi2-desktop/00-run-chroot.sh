#!/bin/bash -e

# On HALPI2 hardware, install the HALPI2 desktop hook metapackage.
# halos-halpi2-desktop Depends on halos-halpi-desktop-branding, which
# Conflicts with halos-desktop-branding, so apt swaps the generic
# wallpaper provider (installed by halos-desktop's Depends on
# halos-desktop-wallpaper) for the HALPI2 one.
#
# On non-HALPI2 desktop builds, halos-halpi2 is absent and this
# substage is a no-op; the generic halos-desktop-branding stays as
# the resolved provider.
#
# Pattern mirrors stage-halos-marine/02-install-combination-metapackage/.

if dpkg -l halos-halpi2 2>/dev/null | grep -q '^ii'; then
    apt-get install -y halos-halpi2-desktop
fi

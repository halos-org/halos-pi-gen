#!/bin/bash -e

# Install halos-halpi2 metapackage if apt.halos.fi is configured.
# RaspiOS images don't have the HaLOS APT source and skip this.
if grep -rq 'apt.halos.fi' /etc/apt/sources.list.d/ 2>/dev/null; then
    apt-get install -y halos-halpi2
fi

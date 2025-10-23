#!/bin/bash -e

# The casaos-docker-service package postinst script will:
# - Create /opt/casa directory
# - Enable casaos.service
# - Start casaos.service
#
# However, during image build, we don't want to start services yet
# So we stop it here and let it start on first boot

# Stop the service if it was started during package installation
systemctl stop casaos.service || true

# Ensure service is enabled for first boot
systemctl enable casaos.service

echo "CasaOS service configured and will start on first boot"
echo "Web interface will be available on port 80"

#!/bin/bash -e

# Create a one-time systemd service to load the Docker image on first boot

# Extract version from the docker-compose.yml
CASA_VERSION=$(grep 'image: dockurr/casa:' /opt/casa/docker-compose.yml | sed 's/.*dockurr\/casa://' | tr -d ' ')

if [ -z "$CASA_VERSION" ]; then
    echo "ERROR: Could not determine CasaOS version from /opt/casa/docker-compose.yml"
    exit 1
fi

echo "Creating systemd service to load dockurr/casa:$CASA_VERSION on first boot..."

# Create a one-shot service to load the Docker image
cat > /etc/systemd/system/load-casa-image.service <<EOF
[Unit]
Description=Load CasaOS Docker Image
Before=casaos.service
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'if [ -f /opt/casa/images/casa-${CASA_VERSION}.tar ]; then docker load -i /opt/casa/images/casa-${CASA_VERSION}.tar && rm /opt/casa/images/casa-${CASA_VERSION}.tar && echo "Loaded CasaOS image from /opt/casa/images/casa-${CASA_VERSION}.tar"; fi'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl enable load-casa-image.service

echo "Docker image will be loaded on first boot from /opt/casa/images/casa-${CASA_VERSION}.tar"
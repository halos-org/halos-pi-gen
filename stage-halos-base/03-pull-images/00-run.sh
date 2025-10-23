#!/bin/bash -e

# This runs on the build host where Docker is available
# Pre-pull the CasaOS Docker image and save it to the image

# Extract version from the docker-compose.yml
CASA_VERSION=$(grep 'image: dockurr/casa:' "${ROOTFS_DIR}/opt/casa/docker-compose.yml" | sed 's/.*dockurr\/casa://' | tr -d ' ')

if [ -z "$CASA_VERSION" ]; then
    echo "ERROR: Could not determine CasaOS version from docker-compose.yml"
    exit 1
fi

# Check if Docker is available (it won't be in act's pi-gen container)
# In CI builds, Docker will be available on the runner
if ! command -v docker &> /dev/null; then
    echo "Docker not available in build environment, skipping image pre-load"
    echo "The image will be pulled on first boot instead"
    echo "NOTE: CI builds with Docker available will pre-load the image for offline use"
    exit 0
fi

echo "Pre-pulling dockurr/casa:$CASA_VERSION image on build host..."

# Pull the image on the build host
docker pull "dockurr/casa:$CASA_VERSION"

# Save the image as a tar file
mkdir -p "${ROOTFS_DIR}/opt/casa/images"
docker save "dockurr/casa:$CASA_VERSION" -o "${ROOTFS_DIR}/opt/casa/images/casa-${CASA_VERSION}.tar"

echo "Successfully saved dockurr/casa:$CASA_VERSION to /opt/casa/images/"

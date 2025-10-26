#!/bin/bash -e

# This runs on the build host (pi-gen Docker container)
# Pre-pull the Runtipi Docker images using skopeo and save them to the image
# Skopeo works without a Docker daemon, so it works in restricted build environments

# Extract versions from the docker-compose.yml
RUNTIPI_VERSION=$(grep 'image: ghcr.io/runtipi/runtipi:' "${ROOTFS_DIR}/opt/runtipi/docker-compose.yml" | sed 's/.*ghcr.io\/runtipi\/runtipi://' | tr -d ' ')
TRAEFIK_VERSION=$(grep 'image: traefik:' "${ROOTFS_DIR}/opt/runtipi/docker-compose.yml" | sed 's/.*traefik://' | tr -d ' ')
POSTGRES_VERSION=$(grep 'image: postgres:' "${ROOTFS_DIR}/opt/runtipi/docker-compose.yml" | sed 's/.*postgres://' | tr -d ' ')

if [ -z "$RUNTIPI_VERSION" ] || [ -z "$TRAEFIK_VERSION" ] || [ -z "$POSTGRES_VERSION" ]; then
    echo "ERROR: Could not determine image versions from docker-compose.yml"
    exit 1
fi

# Install skopeo if not available
if ! command -v skopeo &> /dev/null; then
    echo "skopeo not found, installing..."
    apt-get update
    apt-get install -y skopeo
fi

echo "Pre-pulling Runtipi Docker images using skopeo..."

# Define images to pull
declare -A IMAGES=(
    ["runtipi"]="docker://ghcr.io/runtipi/runtipi:$RUNTIPI_VERSION"
    ["traefik"]="docker://traefik:$TRAEFIK_VERSION"
    ["postgres"]="docker://postgres:$POSTGRES_VERSION"
    ["lavinmq"]="docker://cloudamqp/lavinmq:latest"
)

# Create directory for image tarballs
mkdir -p "${ROOTFS_DIR}/opt/runtipi/images"

# Pull and save each image using skopeo
for NAME in "${!IMAGES[@]}"; do
    IMAGE="${IMAGES[$NAME]}"
    echo "Pulling $IMAGE using skopeo..."

    # Use skopeo to copy the image directly to docker-archive format
    skopeo copy "$IMAGE" "docker-archive:${ROOTFS_DIR}/opt/runtipi/images/${NAME}.tar"

    echo "Saved to /opt/runtipi/images/${NAME}.tar"
done

echo "Successfully saved all Runtipi images to /opt/runtipi/images/"

#!/bin/bash -e

# Pre-install common host-side build tools once for all subsequent HaLOS
# stages. Pi-gen's upstream builder image is minimal; without this, individual
# host-side stage scripts (*-run.sh) would each have to apt-install what they
# need, which is wasteful and easy to forget — missing-tool failures only
# surface in the full integration build. Keep this set minimal: tools that
# more than one host-side stage script needs, or are likely to.
apt-get update -qq
apt-get install -y -qq --no-install-recommends jq python3 >/dev/null

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi

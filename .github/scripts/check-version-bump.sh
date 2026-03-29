#!/bin/bash
# Version bump check for halos-pi-gen (date-based versioning).
#
# The shared version-bump-check workflow doesn't support date-based
# version tags (vYYYY-MM-DD.N-B) or treat config.* / stage-* files
# as package-affecting. This local check fills that gap.
#
# Usage: check-version-bump.sh <base-ref>

set -euo pipefail

BASE_REF="${1:?Usage: $0 <base-ref>}"

git fetch origin "$BASE_REF" --depth=1 2>/dev/null

CHANGED_FILES=$(git diff --name-only "origin/${BASE_REF}...HEAD")

if [ -z "$CHANGED_FILES" ]; then
    echo "No files changed"
    exit 0
fi

if [ ! -f "VERSION" ]; then
    echo "No VERSION file — skipping"
    exit 0
fi

CURRENT_VERSION=$(tr -d '[:space:]' < VERSION)

# Find latest published (non-draft, non-prerelease) release tag.
# halos-pi-gen uses tags like v2026-03-17.0-1
LATEST_TAG=$(gh release list --exclude-drafts --exclude-pre-releases \
    --json tagName --jq '.[].tagName' 2>/dev/null \
    | sort -V | tail -1 || true)

if [ -z "$LATEST_TAG" ]; then
    echo "No published releases found — skipping"
    exit 0
fi

# Extract version from tag: v2026-03-17.0-1 → 2026-03-17.0
TAGGED_VERSION=$(echo "$LATEST_TAG" | sed 's/^v\(.*\)-[0-9]*$/\1/')

if [ "$CURRENT_VERSION" != "$TAGGED_VERSION" ]; then
    echo "VERSION ($CURRENT_VERSION) differs from latest release ($TAGGED_VERSION) — no bump needed"
    exit 0
fi

# VERSION matches latest release — check if image-affecting files changed
IMAGE_FILES=$(echo "$CHANGED_FILES" \
    | grep -v -E '^(VERSION$|.*\.md$|docs/|\.github/|\.claude/|\.vscode/)' \
    | grep -v -E '^(lefthook\.yml$|\.bumpversion\.cfg$|\.gitignore$|\.editorconfig$|LICENSE)' \
    || true)

if [ -z "$IMAGE_FILES" ]; then
    echo "Only non-image files changed — no bump needed"
    exit 0
fi

echo "::error::Image-affecting files changed but VERSION ($CURRENT_VERSION) still matches the latest release ($LATEST_TAG)."
echo ""
echo "Changed image files:"
echo "$IMAGE_FILES" | sed 's/^/  /'
echo ""
echo "Bump the VERSION file (format: YYYY-MM-DD.N) before merging."
exit 1

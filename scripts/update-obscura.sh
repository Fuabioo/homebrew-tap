#!/bin/bash

# Helper script to update the obscura formula with new release information
# Usage: ./scripts/update-obscura.sh <version> [github-token]
# Example: ./scripts/update-obscura.sh 1.2.3

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <version> [github-token]"
    echo "Example: $0 1.2.3"
    echo ""
    echo "Note: GITHUB_TOKEN environment variable must be set if not provided as argument"
    exit 1
fi

VERSION=$1
GITHUB_TOKEN=${2:-$GITHUB_TOKEN}

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN is required"
    echo "Set it as environment variable or pass as second argument"
    exit 1
fi

REPO="Fuabioo/obscura"
TAG="v${VERSION}"
FORMULA_FILE="Formula/obscura.rb"

echo "Updating obscura formula to version ${VERSION}..."

# Function to get SHA256 for a release asset
get_sha256() {
    local asset_name=$1
    local temp_file=$(mktemp)

    echo "Downloading ${asset_name} to calculate SHA256..."

    # Get release information
    local release_info=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
        "https://api.github.com/repos/${REPO}/releases/tags/${TAG}")

    # Extract asset download URL
    local asset_url=$(echo "$release_info" | jq -r ".assets[] | select(.name == \"${asset_name}\") | .url")

    if [ "$asset_url" = "null" ] || [ -z "$asset_url" ]; then
        echo "Error: Asset ${asset_name} not found in release ${TAG}"
        rm -f "$temp_file"
        return 1
    fi

    # Download the asset
    curl -s -L -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/octet-stream" \
        "$asset_url" -o "$temp_file"

    # Calculate SHA256
    if command -v sha256sum >/dev/null 2>&1; then
        local sha256=$(sha256sum "$temp_file" | cut -d' ' -f1)
    elif command -v shasum >/dev/null 2>&1; then
        local sha256=$(shasum -a 256 "$temp_file" | cut -d' ' -f1)
    else
        echo "Error: Neither sha256sum nor shasum found"
        rm -f "$temp_file"
        return 1
    fi

    rm -f "$temp_file"
    echo "$sha256"
}

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required but not installed"
    echo "Install it with: brew install jq"
    exit 1
fi

# Check if release exists
echo "Checking if release ${TAG} exists..."
release_check=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
    "https://api.github.com/repos/${REPO}/releases/tags/${TAG}")

if echo "$release_check" | jq -e '.message == "Not Found"' >/dev/null 2>&1; then
    echo "Error: Release ${TAG} not found in repository ${REPO}"
    exit 1
fi

echo "Release ${TAG} found!"

# Asset names (update these to match your actual release asset names)
ASSETS=(
    "obscura_Darwin_x86_64.tar.gz"
    "obscura_Darwin_arm64.tar.gz"
    "obscura_Linux_x86_64.tar.gz"
    "obscura_Linux_arm64.tar.gz"
)

# Calculate SHA256 for each asset
declare -A CHECKSUMS
for asset in "${ASSETS[@]}"; do
    echo "Processing ${asset}..."
    checksum=$(get_sha256 "$asset")
    if [ $? -eq 0 ]; then
        CHECKSUMS["$asset"]="$checksum"
        echo "✓ ${asset}: ${checksum}"
    else
        echo "✗ Failed to process ${asset}"
        exit 1
    fi
done

echo ""
echo "All checksums calculated successfully!"
echo ""

# Create backup of original formula
cp "$FORMULA_FILE" "${FORMULA_FILE}.backup"

# Update the formula file
echo "Updating formula file..."

# Update version
sed -i.tmp "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA_FILE"

# Update SHA256 checksums
sed -i.tmp "s/sha256 \"update_with_actual_sha256_for_darwin_x86_64\"/sha256 \"${CHECKSUMS['obscura_Darwin_x86_64.tar.gz']}\"/" "$FORMULA_FILE"
sed -i.tmp "s/sha256 \"update_with_actual_sha256_for_darwin_arm64\"/sha256 \"${CHECKSUMS['obscura_Darwin_arm64.tar.gz']}\"/" "$FORMULA_FILE"
sed -i.tmp "s/sha256 \"update_with_actual_sha256_for_linux_x86_64\"/sha256 \"${CHECKSUMS['obscura_Linux_x86_64.tar.gz']}\"/" "$FORMULA_FILE"
sed -i.tmp "s/sha256 \"update_with_actual_sha256_for_linux_arm64\"/sha256 \"${CHECKSUMS['obscura_Linux_arm64.tar.gz']}\"/" "$FORMULA_FILE"

# Clean up temporary files
rm -f "${FORMULA_FILE}.tmp"

echo "✓ Formula updated successfully!"
echo ""
echo "Changes made:"
echo "- Version: ${VERSION}"
echo "- Darwin x86_64 SHA256: ${CHECKSUMS['obscura_Darwin_x86_64.tar.gz']}"
echo "- Darwin arm64 SHA256: ${CHECKSUMS['obscura_Darwin_arm64.tar.gz']}"
echo "- Linux x86_64 SHA256: ${CHECKSUMS['obscura_Linux_x86_64.tar.gz']}"
echo "- Linux arm64 SHA256: ${CHECKSUMS['obscura_Linux_arm64.tar.gz']}"
echo ""
echo "Backup created at: ${FORMULA_FILE}.backup"
echo ""
echo "You can now test the formula with:"
echo "  brew install --build-from-source ./Formula/obscura.rb"
echo ""
echo "Or if you have the tap already added:"
echo "  brew reinstall obscura"

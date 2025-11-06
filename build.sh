#!/bin/bash

echo "Building Unmanic plugin with dependencies..."

# Set variables
PLUGIN_DIR="source/reorder_audio_streams_by_language_set_default"
OUTPUT_ZIP="reorder_audio_streams_by_language_set_default.zip"

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf "${PLUGIN_DIR}/site-packages"
rm -f "${OUTPUT_ZIP}"

# Create site-packages directory
echo "Creating site-packages directory..."
mkdir -p "${PLUGIN_DIR}/site-packages"

# Install dependencies to site-packages
echo "Installing dependencies from requirements.txt..."
pip install --target="${PLUGIN_DIR}/site-packages" -r "${PLUGIN_DIR}/requirements.txt"

# Clean up unnecessary files from site-packages
echo "Cleaning up build artifacts..."
find "${PLUGIN_DIR}/site-packages" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find "${PLUGIN_DIR}/site-packages" -type f -name "*.pyc" -delete 2>/dev/null || true

# Create the zip file (files at root, not in subdirectory)
echo "Creating plugin zip file..."
cd "${PLUGIN_DIR}"
zip -r "../../${OUTPUT_ZIP}" . \
    -x "*.git*" \
    -x "*__pycache__*" \
    -x "*.pyc"
cd ../..

# Calculate zip size
ZIP_SIZE=$(du -h "${OUTPUT_ZIP}" | cut -f1)

echo ""
echo "✅ Build complete!"
echo "📦 Plugin package: ${OUTPUT_ZIP} (${ZIP_SIZE})"
echo ""
echo "Next steps:"
echo "1. Upload ${OUTPUT_ZIP} to Unmanic via the Plugins page"
echo "2. The dependencies will now be bundled and available"

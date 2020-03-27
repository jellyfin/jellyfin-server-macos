#!/bin/bash
set -euo pipefail

# Download and unpack jellyfin into ${PRODUCT_NAME}.app/Contents/Resources
JELLYFIN_TARBALL_URL=$(curl -s https://api.github.com/repos/jellyfin/jellyfin/releases/latest \
| grep "browser_download_url.*macos.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \")


CURL_ARGS="--connect-timeout 5 --max-time 10 --retry 5 --retry-delay 3 --retry-max-time 60"
DL_DIR="${BUILT_PRODUCTS_DIR}/dl"
JELLYFIN_TARBALL="${DL_DIR}/jellyfin.macos.tar.gz"
APP_RESOURCES_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources"
TAR_DIR="${APP_RESOURCES_DIR}/server"

# Download jellyfin tarball
if [ -f "${JELLYFIN_TARBALL}" ]; then
    echo "-- Jellyfin already downloaded"
    echo "   > ${JELLYFIN_TARBALL}"
else
    echo "-- Downloading Jellyfin"
    echo "   From > ${JELLYFIN_TARBALL_URL}"
    echo "     To > ${JELLYFIN_TARBALL}"
    
    mkdir -p "${DL_DIR}"
    curl ${CURL_ARGS} -s -L -o "${JELLYFIN_TARBALL}" ${JELLYFIN_TARBALL_URL}
fi


# Download and unpack FFmpeg/FFprobe in to ${PRODUCT_NAME}.app/Contents/Resources as well
FFMPEG_VERSION="4.2.1"
FFMPEG_FILE="ffmpeg-${FFMPEG_VERSION}-macos64-static.zip"
FFMPEG_ZIP_URL="https://ffmpeg.zeranoe.com/builds/macos64/static/${FFMPEG_FILE}"
FFMPEG_ZIP="${DL_DIR}/${FFMPEG_FILE}"

if [ -f "${FFMPEG_ZIP}" ]; then
    echo "-- FFmpeg already downloaded"
    echo "   > ${FFMPEG_ZIP}"
else
    echo "-- Downloading FFmpeg"
    echo "   From > ${FFMPEG_ZIP_URL}"
    echo "     To > ${FFMPEG_ZIP}"

    curl ${CURL_ARGS} -s -L -o "${FFMPEG_ZIP}" "${FFMPEG_ZIP_URL}"
fi


# Unpack to .app Resources folder
if [ -d "${TAR_DIR}/jellyfin" ]; then
    echo "-- Jellyfin already unpacked"
    echo "   > ${TAR_DIR}"
else
    echo "-- Unpacking jellyfin"
    echo "   > ${TAR_DIR}"
    mkdir -p "${TAR_DIR}"
    tar -xf "${JELLYFIN_TARBALL}" -C "${TAR_DIR}" --strip-components=1
    
    echo "-- Unpacking FFmpeg"
    unzip -o -j "${FFMPEG_ZIP}"  "ffmpeg-${FFMPEG_VERSION}-macos64-static/bin/ffmpeg" "ffmpeg-${FFMPEG_VERSION}-macos64-static/bin/ffprobe" "ffmpeg-${FFMPEG_VERSION}-macos64-static/LICENSE.txt" "ffmpeg-${FFMPEG_VERSION}-macos64-static/README.txt" -d "${TAR_DIR}"
fi

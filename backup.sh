#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

readonly SOURCE_DIR="$PWD"
readonly BACKUP_DIR="$PWD/backups"
readonly DATETIME="$(date '+%Y-%m-%dT%H:%M:%SZ')-$1"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

mkdir -p "${BACKUP_DIR}"

# Pass "incremental" as argument to make incremental backup
# Pass "full" as argument to make full backup
if [ $1 == "incremental" ]; then
    rsync -av --delete \
      "${SOURCE_DIR}/" \
      --link-dest "${LATEST_LINK}" \
      --exclude="backups" \
      "${BACKUP_PATH}"
elif [ $1 == "full" ]; then
    rm -rf "${LATEST_LINK}"
    rm -rf "${BACKUP_DIR}"/*incremental
    rsync -av --delete \
          "${SOURCE_DIR}/" \
          --link-dest "${LATEST_LINK}" \
          --exclude="backups" \
          "${BACKUP_PATH}"
fi

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"

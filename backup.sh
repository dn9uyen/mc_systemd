#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

PORT=25575

SOURCE_DIR="$PWD"
BACKUP_DIR="$PWD/backups"
DATETIME="$(date '+%Y-%m-%dT%H:%M:%SZ')-$1"
BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
LATEST_LINK="${BACKUP_DIR}/latest"

if [ $1 == "restore" ]; then
    rsync -aAXv --delete --exclude="backups" $2 ${SOURCE_DIR}/
    exit 0
fi

mcrcon -P ${PORT} -p password "tellraw @a {\"text\":\"[Backup] Sever backup starting...\",\"color\":\"gray\"}" save-off
sleep 10s
mcrcon -P ${PORT} -p password save-all
sleep 10s

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

mcrcon -P ${PORT} -p password "tellraw @a {\"text\":\"[Backup] Sever backup finished.\",\"color\":\"gray\"}" save-on
BACKUP_SIZE=$(du -hs ${BACKUP_PATH}/world | awk '{print $1}')
mcrcon -P ${PORT} -p password "tellraw @a {\"text\":\"[Backup] World size: ${BACKUP_SIZE}b\",\"color\":\"gray\"}" save-on

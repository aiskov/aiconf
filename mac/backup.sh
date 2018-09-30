#!/usr/bin/env bash

AI_BACKUP_VOLUME=/Volumes/Dump2/

export AI_BACKUP_LOCATION=/Volumes/Dump2/backup-${HOSTNAME}
export AI_BACKUP_DIRS="$HOME/Dropbox $HOME/Development $HOME/Documents $HOME/Gog $HOME/Pictures $HOME/VM"
export AI_BACKUP_REPORT=/tmp/ai_backup

# Just exit if volume unavailable.
if [[ ! -d "${AI_BACKUP_VOLUME}" ]]
then
    echo "Backup volume not found. Skip backup sync operation!"
    exit 0
fi

# Create directory
[[ -d "${AI_BACKUP_LOCATION}" ]] || mkdir "${AI_BACKUP_LOCATION}" || {
    echo "Unable to create backup directory." >&2
    exit 1
}

# Run backup sync
date "+%Y-%m-%dT%H:%M:%S" > ${AI_BACKUP_REPORT}
for BACKUP_DIR in $AI_BACKUP_DIRS
do
    if [[ $(ps aux | grep "rsync -avu ${BACKUP_DIR}" | grep -v grep) ]]
    then   
        echo "Already syncing and will be skiped: ${BACKUP_DIR}"
        continue
    fi

    echo "Backup of directory: ${BACKUP_DIR}"
    nice -n20 rsync -avu --delete --exclude-from "$(dirname ${0})/bash-exclude.txt" "${BACKUP_DIR}" "${AI_BACKUP_LOCATION}"
done
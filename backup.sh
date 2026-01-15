#!/bin/bash
set -e

BACKUP_ROOT="/backups/${MAP}"
DATE=$(date +"%Y-%m-%d_%H-%M")
CURRENT="${BACKUP_ROOT}/${DATE}"
SRC="/ark/ShooterGame/Saved"

# If Ark not installed yet, step ignored
if [ ! -d "$SRC" ]; then
  echo "▶ Backup ignored : First install - No file available"
  exit 0
fi

mkdir -p "$CURRENT"

LAST=$(ls -1dt ${BACKUP_ROOT}/* 2>/dev/null | head -n 1)

if [ -n "$LAST" ]; then
  rsync -a --delete --link-dest="$LAST" "$SRC/" "$CURRENT/"
else
  rsync -a "$SRC/" "$CURRENT/"
fi

tar -czf "${CURRENT}.tar.gz" -C "$CURRENT" .
rm -rf "$CURRENT"

# Rotation 7 jours
find "$BACKUP_ROOT" -name "*.tar.gz" -mtime +7 -delete

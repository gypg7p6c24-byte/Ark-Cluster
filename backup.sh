#!/bin/bash
set -e

BACKUP_DIR="/backups"
ARK_SAVE_DIR="/ark/ShooterGame/Saved"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
BACKUP_FILE="$BACKUP_DIR/ark_backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_FILE" -C "$ARK_SAVE_DIR" .

# garder 10 backups max
ls -1t "$BACKUP_DIR"/ark_backup_*.tar.gz | tail -n +11 | xargs -r rm --

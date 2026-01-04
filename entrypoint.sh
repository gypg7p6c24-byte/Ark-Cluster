#!/bin/bash
set -e

MAP=${MAP}
SESSION_NAME=${SESSION_NAME}
PORT=${PORT}
QUERY_PORT=${QUERY_PORT}
RCON_PORT=${RCON_PORT}
CLUSTER_ID=${CLUSTER_ID}
ADMIN_PASSWORD=${ADMIN_PASSWORD}

echo "▶ Backup de sécurité avant update"
/backup.sh || true

echo "▶ Installing / Updating ARK (${MAP})"
steamcmd +login anonymous \
 +force_install_dir /ark \
 +app_update 376030 validate \
 +quit

# Backups toutes les 6 heures
(crontab -l 2>/dev/null; echo "0 */6 * * * /backup.sh") | crontab -
cron

echo "▶ Starting ARK Map: ${MAP}"

cd /ark/ShooterGame/Binaries/Linux

./ShooterGameServer \
  ${MAP}?SessionName=${SESSION_NAME}?Port=${PORT}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}?ServerAdminPassword=${ADMIN_PASSWORD}?ClusterId=${CLUSTER_ID}?AltSaveDirectoryName=${MAP} \
  -server \
  -log \
  -USEALLAVAILABLECORES \
  -clusterid=${CLUSTER_ID} \
  -ClusterDirOverride=/arkcluster

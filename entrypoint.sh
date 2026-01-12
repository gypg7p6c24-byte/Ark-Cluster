#!/bin/bash
set -e

MAP=${MAP}
SESSION_NAME=${SESSION_NAME}
PORT=${PORT}
QUERY_PORT=${QUERY_PORT}
RCON_PORT=${RCON_PORT}
CLUSTER_ID=${CLUSTER_ID}
ADMIN_PASSWORD=${ADMIN_PASSWORD}

mkdir -p /home/steam/.steam
mkdir -p /home/steam/.steam/steam
mkdir -p /home/steam/.steam/root

echo "▶ Backup de sécurité avant update"
sh /backup.sh || true

echo "▶ Installing / Updating ARK (${MAP})"
steamcmd \
  +force_install_dir /ark \
  +login anonymous \
  +app_update 376030 validate \
  +quit

# Backup toutes les 6h
(crontab -l 2>/dev/null; echo "0 */6 * * * /backup.sh") | crontab -
cron

cd /ark/ShooterGame/Binaries/Linux

./ShooterGameServer \
  ${MAP}?SessionName=${SESSION_NAME}?Port=${PORT}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}?ServerAdminPassword=${ADMIN_PASSWORD}?ClusterId=${CLUSTER_ID}?AltSaveDirectoryName=${MAP} \
  -server -log -USEALLAVAILABLECORES \
  -clusterid=${CLUSTER_ID} \
  -ClusterDirOverride=/arkcluster

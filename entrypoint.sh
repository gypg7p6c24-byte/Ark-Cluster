#!/bin/bash
set -e

ARK_BIN="/ark/ShooterGame/Binaries/Linux/ShooterGameServer"

mkdir -p /home/steam/.steam
mkdir -p /home/steam/.steam/steam
mkdir -p /home/steam/.steam/root

echo "▶ Backup de sécurité avant update"
sh /backup.sh || true

if [ ! -f "$ARK_BIN" ]; then
  echo "▶ ARK non installé, installation en cours"
  steamcmd \
    +force_install_dir /ark \
    +login anonymous \
    +app_update 376030 validate \
    +quit
else
  echo "▶ ARK déjà installé, installation ignorée"
fi

echo "▶ Lancement du serveur ARK (${MAP})"

cd /ark/ShooterGame/Binaries/Linux

exec ./ShooterGameServer \
  ${MAP}?SessionName=${SESSION_NAME}?Port=${PORT}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}?ServerAdminPassword=${ADMIN_PASSWORD}?ClusterId=${CLUSTER_ID}?AltSaveDirectoryName=${MAP} \
  -server -log -USEALLAVAILABLECORES \
  -clusterid=${CLUSTER_ID} \
  -ClusterDirOverride=/arkcluster

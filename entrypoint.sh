#!/bin/bash
set -e

echo "[INFO] Fix permissions on volumes..."
mkdir -p /ark /arkcluster /backups
chown -R steam:steam /ark /arkcluster /backups

# Variables obligatoires
: "${SERVER_MAP:?Missing SERVER_MAP}"
: "${SESSION_NAME:?Missing SESSION_NAME}"
: "${SERVER_PASSWORD:?Missing SERVER_PASSWORD}"
: "${ADMIN_PASSWORD:?Missing ADMIN_PASSWORD}"
: "${MAX_PLAYERS:?Missing MAX_PLAYERS}"
: "${GAME_PORT:?Missing GAME_PORT}"
: "${QUERY_PORT:?Missing QUERY_PORT}"
: "${RCON_PORT:?Missing RCON_PORT}"
: "${CLUSTER_ID:?Missing CLUSTER_ID}"



ARK_DIR="/ark"
SAVE_DIR="${ARK_DIR}/ShooterGame/Saved"
CLUSTER_DIR="${SAVE_DIR}/clusters/${CLUSTER_ID}"

mkdir -p "${CLUSTER_DIR}"

# Construction options serveur
ARGS=(
  "${SERVER_MAP}?listen"
  "SessionName=${SESSION_NAME}"
  "ServerPassword=${SERVER_PASSWORD}"
  "ServerAdminPassword=${ADMIN_PASSWORD}"
  "MaxPlayers=${MAX_PLAYERS}"
  "Port=${GAME_PORT}"
  "QueryPort=${QUERY_PORT}"
  "RCONPort=${QUERY_PORT}"
)

# Mods (optionnel)
if [ -n "${GAME_MOD_IDS}" ]; then
  ARGS+=("GameModIds=${GAME_MOD_IDS}")
fi

# Logs
ARGS+=(
  "-server"
  "-log"
  "-servergamelog"
  "-servergamelogincludetribelogs"
)

# Réseau
ARGS+=(
  "-NoTransferFromFiltering"
  "-ClusterDirOverride=${CLUSTER_DIR}"
)

# Anti-cheat
ARGS+=(
  "-UseBattlEye"
)

# Gameplay
ARGS+=(
  "-AllowThirdPersonPlayer"
)

echo "[ARK] Launch command:"
echo "${ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer ${ARGS[*]}"

exec "${ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer" "${ARGS[@]}"

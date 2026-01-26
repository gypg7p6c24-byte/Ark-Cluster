#!/bin/bash
set -e

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
SERVER_BIN="/ark/ShooterGame/Binaries/Linux/ShooterGameServer"
STEAMCMD="/home/steam/steamcmd/steamcmd.sh"

echo "[ARK] Checking server installation..."

if [ ! -f "$SERVER_BIN" ]; then
  "$STEAMCMD" \
    +force_install_dir /ark \
    +login anonymous \
    +app_update 376030 \
    +quit
echo "[ARK] Server installed"
else
echo "[ARK] Server already installed"
fi

CLUSTER_DIR="/clusters/"

CMD="${SERVER_MAP}?listen?SessionName=${SESSION_NAME}?MaxPlayers=${MAX_PLAYERS}"

# --- Network (FLAGS, pas URL) ---
CMD+=" -Port=${GAME_PORT}"
CMD+=" -QueryPort=${QUERY_PORT}"
CMD+=" -RCONPort=${RCON_PORT}"

# --- Security (FLAGS, CRUCIAL) ---
CMD+=" -ServerPassword=${SERVER_PASSWORD}"
CMD+=" -ServerAdminPassword=${ADMIN_PASSWORD}"

# --- Cluster ---
CMD+=" -ClusterId=${CLUSTER_ID}"
CMD+=" -clusterDirOverride=/clusters"

echo "[ARK] Command: $SERVER_BIN $CMD -server -log"

exec "$SERVER_BIN" "$CMD" -server -log


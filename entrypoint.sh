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
STEAMCMD="${STEAMCMD:-/home/steam/steamcmd/steamcmd.sh}"

echo "[ARK] Checking server installation..."

if [ ! -f "$SERVER_BIN" ]; then
  echo "[ARK] Installing via SteamCMD..."
echo "[ARK] Create Server repository"
  mkdir -p "$ARK_DIR"
echo "[ARK] Repository created"
  "$STEAMCMD" \
    +force_install_dir /ark \
    +login anonymous \
    +app_update 376030 validate \
    +quit
echo "[ARK] Server installed"
else
  echo "[ARK] Server already installed"
fi


SAVE_DIR="${ARK_DIR}/ShooterGame/Saved"
CLUSTER_DIR="${SAVE_DIR}/clusters/"
echo "[ARK] Creating cluster repository"
mkdir -p "${CLUSTER_DIR}"
echo "[ARK] Cluster repository created"
echo "[ARK] Initializing arguments server"
# Server Launching Script
ARGS=(
  "${SERVER_MAP}?listen?SessionName=${SESSION_NAME}?ServerPassword=${SERVER_PASSWORD}?ServerAdminPassword=${ADMIN_PASSWORD}?MaxPlayers=${MAX_PLAYERS}"
)
echo "[ARK] Map, session, password, adm password and max player configurated"
# Mods (optional)
if [ -n "${GAME_MOD_IDS}" ]; then
  ARGS+=("?GameModIds=${GAME_MOD_IDS}")
fi
echo "[ARK] Logs configurated"
# Logs
ARGS+=(
  "-server"
  "-log"
  "-servergamelog"
  "-servergamelogincludetribelogs"
)
echo "[ARK] Network configurated"
# Network
ARGS+=(
  "-Port=${GAME_PORT}"
  "-QueryPort=${QUERY_PORT}"
  "-RCONPort=${RCON_PORT}"
  "-ClusterDirOverride=${CLUSTER_DIR}"
)


echo "[ARK] Starting server..."
"${SERVER_BIN}" "${ARGS[@]}" &
ARK_PID=$!
echo "[ARK] Server Up"
wait "$ARK_PID"

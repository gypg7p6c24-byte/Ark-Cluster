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
SERVER_BIN="${ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer"

echo "[ARK] Checking server installation..."

if [ ! -f "$SERVER_BIN" ]; then
  echo "[ARK] Server not found, installing via SteamCMD..."

  mkdir -p "$ARK_DIR"

  "/usr/games/steamcmd" \
    +force_install_dir "$ARK_DIR" \
    +login anonymous \
    +app_update 376030 validate \
    +quit
else
  echo "[ARK] Server already installed"
fi


SAVE_DIR="${ARK_DIR}/ShooterGame/Saved"
CLUSTER_DIR="${SAVE_DIR}/clusters/"

mkdir -p "${CLUSTER_DIR}"

# Construction options serveur
ARGS=(
  "${SERVER_MAP}?listen?SessionName=${SESSION_NAME}?ServerPassword=${SERVER_PASSWORD}?ServerAdminPassword=${ADMIN_PASSWORD}?MaxPlayers=${MAX_PLAYERS}?Port=${GAME_PORT}?QueryPort=${QUERY_PORT}?RCONPort=${RCON_PORT}"
)

# Mods (optionnel)
if [ -n "${GAME_MOD_IDS}" ]; then
  ARGS+=("?GameModIds=${GAME_MOD_IDS}")
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
  "-ClusterDirOverride=${CLUSTER_DIR}"
)



echo "[ARK] Launch command:"
echo "${ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer ${ARGS[*]}"

exec "${ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer" "${ARGS[@]}"

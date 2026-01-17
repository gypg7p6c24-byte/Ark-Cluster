#!/bin/bash
set -e

: "${MAP:?MAP is required}"
: "${SESSION_NAME:?SESSION_NAME is required}"
: "${PORT:?PORT is required}"
: "${QUERY_PORT:?QUERY_PORT is required}"
: "${RCON_PORT:?RCON_PORT is required}"
: "${CLUSTER_ID:?CLUSTER_ID is required}"
: "${ADMIN_PASSWORD:?ADMIN_PASSWORD is required}"

# Installation ARK si absent
if [ ! -f "$ARK_BIN" ]; then
  "$STEAMCMD" +login anonymous \
    +force_install_dir "$ARK_DIR" \
    +app_update 376030 validate \
    +quit
fi

INI="/ark/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini"
mkdir -p "$(dirname "$INI")"

grep -q "RCONEnabled=True" "$INI" 2>/dev/null || cat >> "$INI" <<EOF

[RCON]
RCONEnabled=True
RCONPort=$RCON_PORT
ServerAdminPassword=$ADMIN_PASSWORD
EOF

exec "$ARK_BIN" "$MAP?listen?RCONEnabled=True" \
  -SessionName="$SESSION_NAME" \
  -Port="$PORT" \
  -QueryPort="$QUERY_PORT" \
  -RCONPort="$RCON_PORT" \
  -clusterid="$CLUSTER_ID" \
  -ClusterDirOverride=/arkcluster \
  -server \
  -log

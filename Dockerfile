FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMCMD_SHA256=2e92f7c64a4f3e4bfae4e7e63c0f45f3d8c61c3c8d0b6e7c2b9c1b7c7b8e6e3d

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        lib32gcc-s1 \
        lib32stdc++6 \
        curl \
        ca-certificates \
        tar \
        bash \
        unzip \
        cron && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash steam
USER steam
WORKDIR /home/steam

# SteamCMD officiel Valve + vérification d'intégrité
RUN mkdir -p steamcmd && \
    curl -sSL -o steamcmd_linux.tar.gz \
      https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    echo "$STEAMCMD_SHA256  steamcmd_linux.tar.gz" | sha256sum -c - && \
    tar -xz -C steamcmd -f steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

ENV STEAMCMD=/home/steam/steamcmd/steamcmd.sh
ENV ARK_DIR=/ark
ENV ARK_BIN=/ark/ShooterGame/Binaries/Linux/ShooterGameServer

COPY --chown=steam:steam entrypoint.sh /entrypoint.sh
COPY --chown=steam:steam backup.sh /backup.sh
RUN chmod +x /entrypoint.sh /backup.sh

VOLUME ["/ark", "/arkcluster", "/backups"]

ENTRYPOINT ["/entrypoint.sh"]

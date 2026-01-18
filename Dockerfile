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

# Official SteamCMD Valve + integirty checking
RUN mkdir -p steamcmd && \
    curl -sSL -o steamcmd_linux.tar.gz \
      https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xz -C steamcmd -f steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz


ENV STEAMCMD=/home/steam/steamcmd/steamcmd.sh
ENV ARK_DIR=/ark
ENV ARK_BIN=/ark/ShooterGame/Binaries/Linux/ShooterGameServer

COPY --chown=steam:steam entrypoint.sh /entrypoint.sh
COPY --chown=steam:steam backup.sh /backup.sh
RUN chmod +x /entrypoint.sh /backup.sh

VOLUME ["/ark", "/arkcluster", "/backups"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=2m --retries=3 \
  CMD pgrep ShooterGameServer >/dev/null || exit 1
  Ò
ENTRYPOINT ["/entrypoint.sh"]

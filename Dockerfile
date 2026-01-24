FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMCMD_SHA256=2e92f7c64a4f3e4bfae4e7e63c0f45f3d8c61c3c8d0b6e7c2b9c1b7c7b8e6e3d

RUN dpkg --add-architecture i386 \
 && apt update \
 && echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note "" | debconf-set-selections \
 && apt install -y --no-install-recommends \
    lib32gcc-s1 \
    lib32stdc++6 \
    ca-certificates \
    curl \
    cron \
    procps \
    rsync \
 && useradd -m steam \
 && mkdir -p /ark /arkcluster /backups \
 && chown -R steam:steam /ark /arkcluster /backups \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

USER steam
WORKDIR /home/steam

# Official SteamCMD Valve + integrity checking
RUN mkdir -p steamcmd && \
    curl -sSL -o steamcmd_linux.tar.gz \
      https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    echo "${STEAMCMD_SHA256}  steamcmd_linux.tar.gz" | sha256sum -c - &&\
    tar -xzf steamcmd -f steamcmd_linux.tar.gz -C && \
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

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

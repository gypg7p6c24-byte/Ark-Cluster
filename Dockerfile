FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
 && apt update \
 && apt install -y --no-install-recommends \
    lib32gcc-s1 \
    lib32stdc++6 \
    ca-certificates \
    curl \
    cron \
    procps \
    rsync \
 && useradd -m steam \
 && mkdir -p /ark /cluster /backups \
 && chown -R steam:steam /ark /arkcluster /backups \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

USER steam
WORKDIR /home/steam

RUN mkdir -p steamcmd \
 && curl -sSL -o steamcmd_linux.tar.gz \
    https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
 && tar -xzf steamcmd_linux.tar.gz -C steamcmd \
 && rm steamcmd_linux.tar.gz

COPY --chown=steam:steam entrypoint.sh /entrypoint.sh
COPY --chown=steam:steam backup.sh /backup.sh
RUN chmod +x /entrypoint.sh /backup.sh

VOLUME ["/ark", "/arkcluster", "/backups"]

ENTRYPOINT ["/entrypoint.sh"]

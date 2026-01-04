FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
 && apt update \
 && echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note "" | debconf-set-selections \
 && apt install -y \
    steamcmd \
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
WORKDIR /ark

COPY --chown=steam:steam entrypoint.sh /entrypoint.sh
COPY --chown=steam:steam backup.sh /backup.sh

RUN chmod +x /entrypoint.sh /backup.sh

ENTRYPOINT ["/entrypoint.sh"]

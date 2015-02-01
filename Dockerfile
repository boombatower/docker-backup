# http://docs.docker.com/reference/builder
# docker backup image (boombatower/docker-backup).

FROM boombatower/opensuse
MAINTAINER Jimmy Berry <jimmy@boombatower.com>

RUN zypper refresh && \
    zypper -n in --no-recommends tar xz

ADD backup.sh /root/bin/

VOLUME /backup
ENTRYPOINT ["/root/bin/backup.sh"]
CMD ["backup"]

# http://docs.docker.com/reference/builder
# docker backup via s3 image (boombatower/docker-backup-s3).

FROM boombatower/docker-backup
MAINTAINER Jimmy Berry <jimmy@boombatower.com>

RUN zypper refresh && \
    zypper -n in --no-recommends python-boto python-dateutil python-magic python-xml

ADD https://github.com/s3tools/s3cmd/archive/v1.5.0.tar.gz /root/
RUN cd /root && tar -zxvf v1.5.0.tar.gz && cd s3cmd-1.5.0 && python setup.py install

ADD s3.sh /root/bin/

ENTRYPOINT ["/root/bin/s3.sh"]
CMD ["backup"]

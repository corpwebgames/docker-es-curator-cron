FROM alpine:3.6

ENV CURATOR_VERSION=3.5.1

RUN apk --update add dcron wget rsync ca-certificates python py-setuptools py-pip && \
    pip install elasticsearch-curator==${CURATOR_VERSION} && \
    pip install requests-aws4auth && \
    pip --no-cache-dir install awscli && \
    apk del py-pip && \
    rm -rf /var/cache/apk/*

ADD init-cron.sh /opt/
RUN chmod +x /opt/init-cron.sh

WORKDIR /opt

CMD ["./init-cron.sh"]
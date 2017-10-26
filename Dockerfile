FROM alpine:3.6

ENV CURATOR_VERSION=3.5.1

RUN apk --update add dcron wget rsync ca-certificates python py-setuptools py-pip && \
    pip install elasticsearch-curator==${CURATOR_VERSION} && \
    pip install requests-aws4auth && \
    pip --no-cache-dir install awscli && \
    apk del py-pip && \
    rm -rf /var/cache/apk/*

ENV ES_HOST=localhost

ENV ES_PORT=9200

ENV CURATOR_EX_OPTS=

ADD init-cron.sh /opt/
RUN chmod +x /opt/init-cron.sh

ADD curator-runner.sh /opt/
RUN chmod +x /opt/curator-runner.sh

WORKDIR /opt

CMD ["./init-cron.sh"]
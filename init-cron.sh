#!/bin/sh

if [ -z "$S3_CRON_FILE" ]; then echo "S3_CRON_FILE is unset"; exit 1; fi

aws s3 cp $S3_CRON_FILE /etc/cron.d/cron-jobs
chmod 0644 /etc/cron.d/cron-jobs

touch /var/log/cron.log

crond -s /etc/cron.d/ -b -L /var/log/cron.log && tail -f /var/log/cron.log

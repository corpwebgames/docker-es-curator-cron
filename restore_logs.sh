#!/bin/sh

if [ "$REPOSITORY" == "" ];then
	REPOSITORY="logs_archive"
fi
if [ "$INDEX_PREFIX" == "" ];then
	INDEX_PREFIX="logstash"
fi
if [ "$2" != "" ];then
 min_week=`expr "$2" + "$1"`
 FILTER="--newer-than $min_week"
fi
echo "prepare restoring $INDEX_PREFIX --older-than $1 $FILTER weeks stored in repository $REPOSITORY "
cat <<EOF >/tmp/payload.json
{"rename_pattern": "${INDEX_PREFIX}-(.+)", "rename_replacement": "archive_${INDEX_PREFIX}-\$1"}
EOF
echo "$(/usr/bin/curator --host $ES_HOST --quiet --loglevel ERROR show snapshots --repository $REPOSITORY --time-unit weeks --older-than $1 $FILTER)" | while read -r la
do 
 if [ "$la" != "" ];then
  echo "try restore $la"
  curl -XPOST ${ES_HOST}:${ES_PORT}/_snapshot/${REPOSITORY}/${la}/_restore?wait_for_completion=true -H 'Content-Type: application/json' \
  -d @/tmp/payload.json
 fi
done

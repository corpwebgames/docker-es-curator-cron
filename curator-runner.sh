#!/bin/sh
echo "run curator with options --host $ES_HOST --port $ES_PORT $CURATOR_EX_OPTS $@"
/usr/bin/curator --host $ES_HOST --port $ES_PORT $CURATOR_EX_OPTS "$@"
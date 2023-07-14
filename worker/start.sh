#!/bin/bash
if [ ! -n "$WORKER_NUMBER" ]; then
    echo "error: WORKER_NUMBER not defined!"
    exit -1
fi

if [ ! -n "$WORKER_ID" ]; then
    echo "error: WORKER_ID not defined!"
    exit -1
fi

export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

#if [ ! -d $SHELL_FOLDER/../.config ]; then
#    echo "error: config not found!"
#    exit -1
#fi
#export CONFIG_FOLDER=$(cd "$(dirname "$0")/../.config";pwd)

echo "start hadoop-worker-$WORKER_ID"
docker compose -f "$SHELL_FOLDER/docker-compose.yml" -p hadoop-worker-$WORKER_ID up -d




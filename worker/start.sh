#!/bin/bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
if [ ! -n "$WORKER_ID" ]; then
    echo "error: WORKER_ID not defined!"
    exit -1
fi

echo "start hadoop-worker-$WORKER_ID"
docker-compose -f "$SHELL_FOLDER/docker-compose.yml" -p hadoop-worker-$WORKER_ID up -d




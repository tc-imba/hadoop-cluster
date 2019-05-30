#!/bin/bash
if [ ! -n "$WORKER_ID" ]; then
    echo "error: WORKER_ID not defined!"
    exit -1
fi

echo "stop hadoop-worker-$WORKER_ID"
docker-compose -p hadoop-worker-$WORKER_ID stop




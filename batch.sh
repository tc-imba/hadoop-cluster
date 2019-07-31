#!/bin/bash

if [ ! -n "$WORKER_NUMBER" ]; then
    echo "error: WORKER_NUMBER not defined!"
    exit -1
fi

for ((i=2;i<=WORKER_NUMBER;i++)); do
    ssh hadoop$i "export WORKER_NUMBER=$WORKER_NUMBER; export WORKER_ID=$i; cd hadoop-cluster; git pull; worker/stop.sh; build/docker-build-image.sh; worker/start.sh" &
done

#!/bin/bash
export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

read -p "input the worker number: " WORKER_NUMBER
rm -f "$SHELL_FOLDER/workers"
for ((i=1;i<=WORKER_NUMBER;i++)); do
    echo "hadoop-worker-$i" >> "$SHELL_FOLDER/workers"
done

echo "start hadoop-master"
docker-compose -f "$SHELL_FOLDER/docker-compose.yml" -p hadoop-master up -d


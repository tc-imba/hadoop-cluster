#!/bin/bash
export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

echo "clean hadoop-master"
docker-compose -f "$SHELL_FOLDER/docker-compose.yml" -p hadoop-master rm
docker network rm hadoop-net

#!/bin/bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

echo "start hadoop-master"
docker-compose -f "$SHELL_FOLDER/docker-compose.yml" -p hadoop-master up -d




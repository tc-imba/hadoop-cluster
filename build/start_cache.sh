#!/bin/bash

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

echo -e "\nbuild and start apt-cache\n"
docker build -t tcimba/hadoop-cluster-apt-cache:latest $SHELL_FOLDER/apt-cache

docker-compose -f "$SHELL_FOLDER/apt-cache/docker-compose.yml" -p hadoop-apt-cache up -d


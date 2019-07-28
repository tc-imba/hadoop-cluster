#!/bin/bash

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

echo -e "\nbuild docker hadoop image\n"
docker build -t tcimba/hadoop-cluster:latest $SHELL_FOLDER/.. --network=hadoop-net

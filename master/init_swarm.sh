#!/bin/bash
export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
export IP_ADDR=$(hostname -I | awk '{print $1}')

echo "init swarm with master ip: ${IP_ADDR}"
docker swarm init --advertise-addr=$IP_ADDR


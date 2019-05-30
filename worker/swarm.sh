#!/bin/bash
export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
export IP_ADDR=$(hostname -I | awk '{print $1}')

read -p "input the master token: " MASTER_TOKEN
read -p "input the master ip: " MASTER_IP_ADDR

echo "join swarm with ip: $IP_ADDR"
docker swarm join --token $MASTER_TOKEN --advertise-addr $IP_ADDR $MASTER_IP_ADDR:2377 



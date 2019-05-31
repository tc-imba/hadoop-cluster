#!/bin/bash
export SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
export IP_ADDR=$(hostname -I | awk '{print $1}')

if [ -z $1 ]; then
    read -p "input the master token: " MASTER_TOKEN
else
    MASTER_TOKEN=$1
    echo "use master token: $MASTER_TOKEN"
fi
if [ -z $2 ]; then
    read -p "input the master ip: " MASTER_IP_ADDR
else
    MASTER_IP_ADDR=$2
    echo "use master ip: $MASTER_IP_ADDR"
fi

echo "join swarm with ip: $IP_ADDR"
docker swarm join --token $MASTER_TOKEN --advertise-addr $IP_ADDR $MASTER_IP_ADDR:2377 

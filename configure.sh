#!/bin/bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
CONFIG_FOLDER=$SHELL_FOLDER/.config
mkdir -p $CONFIG_FOLDER

#read -p "input the worker number: " WORKER_NUMBER
#rm -f "$CONFIG_FOLDER/master/workers"
#cp "$SHELL_FOLDER/config/zookeeper/zoo.cfg" "$CONFIG_FOLDER/zoo.cfg"

#for ((i=1;i<=WORKER_NUMBER;i++)); do
#    echo "hadoop-worker-$i" >> "$CONFIG_FOLDER/workers"
#    echo "server.$i=hadoop-worker-$i:2888:3888" >> "$CONFIG_FOLDER/zoo.cfg"
#done

ssh-keygen -t rsa -f $CONFIG_FOLDER/id_rsa -P ''

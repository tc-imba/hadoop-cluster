#!/bin/bash
service ssh start
# create myid file in dataDir
ZOOKEEPER_ID=$1
echo ${ZOOKEEPER_ID} > /usr/local/zookeeper/data/myid
# start zookeeper
zkServer.sh start
# start drill
drillbit.sh start 
bash

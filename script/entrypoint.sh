#!/bin/bash

# init hdfs for a new node
# the ${HADOOP_HOME}/hdfs/data needs to be mounted
mkdir -p ${HADOOP_HOME}/hdfs/data/dataNode
mkdir -p ${HADOOP_HOME}/hdfs/data/nameNode
if [ "`ls -A ${HADOOP_HOME}/hdfs/data/nameNode`" = "" ]; then
    ${HADOOP_HOME}/bin/hdfs namenode -format hadoop-cluster
    #echo "$DIRECTORY is indeed empty"
fi

service ssh start
# create myid file in dataDir
#ZOOKEEPER_ID=$1
#echo ${ZOOKEEPER_ID} > /usr/local/zookeeper/data/myid
# start zookeeper
#zkServer.sh start
# start drill
#drillbit.sh start 
bash

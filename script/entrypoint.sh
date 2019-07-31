#!/bin/bash

# init user and groups
# useradd -u 1500 -s /bin/bash hadoop
if [ ! -d "/home/hadoop" ]; then
    mkdir -p /home/hadoop
    chown -R hadoop:hadoop /home/hadoop
fi
echo "hadoop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

for ((i=1;i<=10;i++)); do
    let "uid=$i+1500"
    useradd -u $uid -s /bin/bash -d /home/pgroup$i -m pgroup$i
    usermod -a -G hadoop pgroup$i
done

# init hdfs for a new node
# the ${HADOOP_HOME}/hdfs/data needs to be mounted
mkdir -p ${HADOOP_HOME}/hdfs/data/dataNode
mkdir -p ${HADOOP_HOME}/hdfs/data/nameNode
if [ "`ls -A ${HADOOP_HOME}/hdfs/data/nameNode`" = "" ]; then
    ${HADOOP_HOME}/bin/hdfs namenode -format hadoop-cluster
    #echo "$DIRECTORY is indeed empty"
fi

service ssh start

WORKER_NUMBER=$1
WORKER_ID=$2

if [ "${WORKER_ID}" = "0" ]; then
    for ((i=1;i<=WORKER_NUMBER;i++)); do
        echo "hadoop-worker-$i" >> "${HADOOP_HOME}/etc/hadoop/workers"
    done
fi

cp ${ZOOKEEPER_HOME}/conf/zoo.template.cfg ${ZOOKEEPER_HOME}/conf/zoo.cfg
for ((i=1;i<=WORKER_NUMBER;i++)); do
    echo "server.$i=hadoop-worker-$i:2888:3888" >> "${ZOOKEEPER_HOME}/conf/zoo.cfg"
done
echo ${WORKER_ID} > ${ZOOKEEPER_HOME}/data/myid

ZK_CONNECT="hadoop-master:2181"
for ((i=1;i<=WORKER_NUMBER;i++)); do
    ZK_CONNECT=${ZK_CONNECT},hadoop-worker-$i:2181
done
echo "
drill.exec: {
  cluster-id: \"hadoopcluster\",
  zk.connect: \"${ZK_CONNECT}\"
}
" > ${DRILL_HOME}/conf/drill-override.conf

# start zookeeper
${ZOOKEEPER_HOME}/bin/zkServer.sh start

# start drill
${DRILL_HOME}/bin/drillbit.sh start 

chmod -R 777 ${HADOOP_HOME}/logs
chown -R hadoop:hadoop ${HADOOP_HOME}/logs
chmod -R 777 ${DRILL_HOME}/log
chown -R hadoop:hadoop ${DRILL_HOME}/log

zsh

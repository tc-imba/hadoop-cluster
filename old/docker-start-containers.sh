#!/bin/bash
echo "start hadoop-master container..."
docker rm -f hadoop-master &> /dev/null
docker run -itd \
    --net hadoop \
    -p 9870:9870 \
    -p 8088:8088 \
    -p 8047:8047 \
    --mount src=hdfs_data,dst=/usr/local/hadoop/hdfs/data \
    --name hadoop-master \
    --hostname hadoop-master \
    hadoop-cluster:latest

for i in {1..3}
do
    docker rm -f hadoop-worker-${i} &> /dev/null
    echo "start hadoop-worker-$i container..."
    docker run -itd \
        --net=hadoop \
        --name hadoop-worker-${i} \
        --hostname hadoop-worker-${i} \
        --mount src=hdfs_data_${i},dst=/usr/local/hadoop/hdfs/data \
        hadoop-cluster:latest
done

docker exec -it hadoop-master bash

#!/bin/bash
echo "start hadoop-master container..."
docker run -itd \
    --net=hadoop \
    -p 9870:9870 \
    -p 8088:8088 \
    -p 8047:8047 \
    --name hadoop-master \
    --hostname hadoop-master \
    zzhou612/hadoop:1.0 0

for i in {1..3}
do
    docker rm -f hadoop-worker-${i} &> /dev/null
    echo "start hadoop-worker-$i container..."
    docker run -itd \
        --net=hadoop \
        --name hadoop-worker-${i} \
        --hostname hadoop-worker-${i} \
        zzhou612/hadoop:1.0 ${i}
done

docker exec -it hadoop-master bash

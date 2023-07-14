#!/bin/bash

HADOOP_VERSION=3.3.2
DRILL_VERSION=1.20.3
ZOOKEEPER_VERSION=3.7.1
SPARK_VERSION=2.4.8

SHELL_FOLDER=$(
    cd "$(dirname "$0")"
    pwd
)
TARBALL_FOLDER=$SHELL_FOLDER/tarballs
mkdir -p $TARBALL_FOLDER
#cd $SHELL_FOLDER/tarballs

echo tarball directory: $TARBALL_FOLDER

function check_download {

    filename=$1
    filepath=$TARBALL_FOLDER/$filename
    url=$2/$filename

    if [ -f "$filepath" ]; then
        echo "found: $1!"

        downloadedsize=$(stat -c '%s' $filepath | tr -d '\r\n')
        filesize=$(curl -sI $url | grep -i Content-Length | awk '{print $2}' | tr -d '\r\n')

        if [ "$downloadedsize" = "$filesize" ]; then
            echo "skiped: $1 filesize correct!"
            return
        fi

        echo "error: $1 filesize incorrect!"

    fi
    curl -o $filepath $url
    echo "downloaded: $1!"
}

function download_hadoop {
    check_download hadoop-$HADOOP_VERSION.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}
}

function download_drill {
    check_download apache-drill-$DRILL_VERSION.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/drill/${DRILL_VERSION}
}

function download_zookeeper {
    check_download apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}
}

function download_spark {
    check_download spark-$SPARK_VERSION-bin-without-hadoop.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}
}

case $1 in
hadoop) download_hadoop ;;
drill) download_drill ;;
zookeeper) download_zookeeper ;;
spark) download_spark ;;
*)
    download_hadoop
    download_drill
    download_zookeeper
    download_spark
    ;;
esac

#check_download pyspark-$SPARK_VERSION.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-2.4.3/

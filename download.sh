#!/bin/bash

HADOOP_VERSION=3.2.0
DRILL_VERSION=1.16.0
ZOOKEEPER_VERSION=3.5.5

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
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

        downloadedsize=`stat -c '%s' $filepath | tr -d '\r\n'`
        filesize=`curl -sI $url | grep -i Content-Length | awk '{print $2}' | tr -d '\r\n'`
        
        if [ "$downloadedsize" = "$filesize" ]; then
            echo "skiped: $1 filesize correct!"
            return
        fi
        
        echo "error: $1 filesize incorrect!"

    fi
    curl -o $filepath $url
    echo "downloaded: $1!"
}

check_download hadoop-$HADOOP_VERSION.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}

check_download apache-drill-$DRILL_VERSION.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/drill/drill-${DRILL_VERSION}

check_download apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}



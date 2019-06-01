FROM ubuntu:18.04
ARG HADOOP_VERSION=3.2.0
#ARG ZOOKEEPER_VERSION=3.4.13
#ARG DRILL_VERSION=1.13.0
WORKDIR /root


# install openssh-server, openjdk, wget and lsb-core (for drill)
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
COPY config/apt/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y openssh-server curl

# generate & configure ssh key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
COPY config/ssh/config .ssh/config

# JDK 11 will be supported by hadoop 3.3.0
ENV JDK_VERSION=8 
ENV JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
RUN apt-get install -y openjdk-${JDK_VERSION}-jdk-headless

# setup environment variables for hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar:${HADOOP_CLASSPATH}
ENV PATH=${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}

# install & configure hadoop
RUN curl -O https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzvf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz
#RUN mkdir -p ${HADOOP_HOME}/hdfs/data/nameNode && \
#    mkdir -p ${HADOOP_HOME}/hdfs/data/dataNode
COPY config/hadoop/* ${HADOOP_HOME}/etc/hadoop/




#ENV ZOOKEEPER_HOME=/usr/local/zookeeper
#ENV DRILL_HOME=/usr/local/drill
#ENV PATH=${DRILL_HOME}/bin:${JAVA_HOME}/bin:${ZOOKEEPER_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}

# format hdfs
#RUN ${HADOOP_HOME}/bin/hdfs namenode -format

# install & configure zookeeper
# RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
#    tar -xzvf zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
#    mv zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper && \
#    rm zookeeper-${ZOOKEEPER_VERSION}.tar.gz
# RUN mkdir -p ${ZOOKEEPER_HOME}/data
# COPY config/zookeeper/* ${ZOOKEEPER_HOME}/conf/

# install & configure drill
# RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/drill/drill-${DRILL_VERSION}/apache-drill-${DRILL_VERSION}.tar.gz && \
#    tar -xzvf apache-drill-${DRILL_VERSION}.tar.gz && \
#    mv apache-drill-${DRILL_VERSION} /usr/local/drill && \
#    rm apache-drill-${DRILL_VERSION}.tar.gz
# COPY config/drill/* ${DRILL_HOME}/conf/

# install utils
RUN apt-get install -y  net-tools

# copy bash scripts
COPY script/* ./
RUN chmod +x ~/entrypoint.sh && \
    chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x ${HADOOP_HOME}/sbin/start-dfs.sh && \
    chmod +x ${HADOOP_HOME}/sbin/start-yarn.sh

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["0"]

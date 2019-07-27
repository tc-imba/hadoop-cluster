FROM ubuntu:18.04
WORKDIR /root

# install openssh-server, curl, python and scala (for spark)
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
COPY config/apt/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y openssh-server curl python3 python3-pip scala

# generate & configure ssh key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
COPY config/ssh/config .ssh/config

# JDK 11 will be supported by hadoop 3.3.0
ENV JDK_VERSION=8 
ENV JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
RUN apt-get install -y openjdk-${JDK_VERSION}-jdk-headless

# copy downloaded files and download new files
COPY tarballs/* tarballs/
COPY download.sh ./
RUN bash download.sh

# setup hadoop user group
RUN useradd -u 1500 -s /bin/bash -d /home/hadoop hadoop

# install utils
RUN apt-get install -y apt-utils net-tools locales pv pandoc
RUN locale-gen en_US.UTF-8

# setup environment variables for hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar:${HADOOP_CLASSPATH}
ENV PATH=${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}

# install & configure hadoop
ARG HADOOP_VERSION=3.2.0
RUN pv -n tarballs/hadoop-${HADOOP_VERSION}.tar.gz | \
    tar --owner=hadoop --group=hadoop --mode='g+wx' -xzf - && \
    mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
    rm tarballs/hadoop-${HADOOP_VERSION}.tar.gz
#RUN mkdir -p ${HADOOP_HOME}/hdfs/data/nameNode && \
#    mkdir -p ${HADOOP_HOME}/hdfs/data/dataNode
COPY config/hadoop/* ${HADOOP_HOME}/etc/hadoop/
ENV LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native

# install & configure drill
ARG DRILL_VERSION=1.16.0
ENV DRILL_HOME=/usr/local/drill
RUN pv -n tarballs/apache-drill-${DRILL_VERSION}.tar.gz | \
    tar --owner=hadoop --group=hadoop --mode='g+wx' -xzf - && \
    mv apache-drill-${DRILL_VERSION} ${DRILL_HOME} && \
    rm tarballs/apache-drill-${DRILL_VERSION}.tar.gz
COPY config/drill/* ${DRILL_HOME}/conf/
ENV PATH=${DRILL_HOME}/bin:${PATH}

# install & configure zookeeper
ARG ZOOKEEPER_VERSION=3.5.5
ENV ZOOKEEPER_HOME=/usr/local/zookeeper
RUN pv -n tarballs/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz | \
    tar --owner=hadoop --group=hadoop --mode='g+wx' -xzf - && \
    mv apache-zookeeper-${ZOOKEEPER_VERSION}-bin ${ZOOKEEPER_HOME} && \
    rm tarballs/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz
# RUN mkdir -p ${ZOOKEEPER_HOME}/data
COPY config/zookeeper/* ${ZOOKEEPER_HOME}/conf/
ENV PATH=${ZOOKEEPER_HOME}/bin:${PATH}

# install & configure spark
ARG SPARK_VERSION=2.4.3
ENV SPARK_HOME=/usr/local/spark
#RUN pip3 install tarballs/pyspark-${SPARK_VERSION}.tar.gz && \
#    rm tarballs/pyspark-${SPARK_VERSION}.tar.gz
RUN pv -n tarballs/spark-${SPARK_VERSION}-bin-without-hadoop.tgz | \
    tar --owner=hadoop --group=hadoop --mode='g+wx' -xzf - && \
    mv spark-${SPARK_VERSION}-bin-without-hadoop ${SPARK_HOME} && \
    rm tarballs/spark-${SPARK_VERSION}-bin-without-hadoop.tgz
#RUN cd ${SPARK_HOME}/python && \
#    python3 setup.py sdist > /dev/null && \
#    pip3 install dist/pyspark-${SPARK_VERSION}.tar.gz && \
#    rm dist/pyspark-${SPARK_VERSION}.tar.gz
COPY config/spark/* ${SPARK_HOME}/conf/
ENV PATH=${SPARK_HOME}/bin:${PATH}

# install softwares
RUN apt-get install -y man vim nano sudo git zsh
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
COPY config/zsh/* ./

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


#RUN useradd -u 1500 -s /bin/bash hadoop && \
#    chown -R hadoop:hadoop ${HADOOP_HOME} ${DRILL_HOME} ${ZOOKEEPER_HOME} && \
#    chmod -R g+wx ${HADOOP_HOME} ${DRILL_HOME} ${ZOOKEEPER_HOME}

# copy bash scripts
COPY script/* ./
RUN chmod +x ~/entrypoint.sh && \
    chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x ${HADOOP_HOME}/sbin/start-dfs.sh && \
    chmod +x ${HADOOP_HOME}/sbin/start-yarn.sh

ENTRYPOINT ["/root/entrypoint.sh"]
#CMD ["0"]

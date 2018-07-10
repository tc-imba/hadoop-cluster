# Hadoop Cluster
A naive Hadoop cluster consists of multiple docker containers (1 master and 2 workers).

1. Build docker image.
```bash
./docker-build-image.sh
```
2. Create a Hadoop network.
```bash
docker network create --driver=bridge hadoop
```
3. Start containers. 
```bash
./docker-start-container.sh
```
4. Start NameNode daemon, DataNode daemon, ResourceManager daemon and NodeManager daemon.
```bash
./start-hadoop.sh
```
5. Run WordCount example.
```bash
./run-wordcount.sh
```

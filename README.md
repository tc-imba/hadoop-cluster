# Hadoop Cluster
A naive Hadoop cluster consists of multiple Docker containers (1 master and 2 workers).

- [x] Deploy a Hadoop cluster on a single machine with multiple Docker containers.
- [x] Deploy a fully distributed Hadoop cluster on multiple host machines by connecting the standalone containers with Docker swarm overlay network.
- [ ] Using `docker stack` and `docker-compose` to achieve swift & flexible deployment of Hadoop cluster as services on Docker swarm.

### Deploy & Test Hadoop Cluster Locally

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
1. Start NameNode daemon, DataNode daemon, ResourceManager daemon and NodeManager daemon in `hadoop-master` container.
```bash
./start-hadoop.sh
```
5. Run WordCount example in `hadoop-master` container.
```bash
./run-wordcount.sh
```

### Deploy Hadoop Cluster on Multiple Host Machines
1. On `manager`, initialize the swarm.
```bash
docker swarm init --advertise-addr=<IP-ADDRESS-OF-MANAGER>
```

1. On `worker-n`, join the swarm. If the host only has one network interface, the --advertise-addr flag is optional.
```bash
docker swarm --join --token <TOKEN> \
  --advertise-addr <IP-ADDRESS-OF-WORKER-N> \
  <IP-ADDRESS-OF-MANAGER>:2377
```

3. On `manager`, create an attachable overlay network called `hadoop-net`.
```bash
docker network create --driver=overlay --attachable hadoop-net
```

4. On `manager`, start an interactive (-it) container `hadoop-master` that connects to `hadoop-net`.
```bash
docker run -it \
  --name hadoop-master \
  --hostname hadoop-master \
  --network hadoop-net \
  zzhou612/hadoop-cluster:latest
```

5. On `worker-n`, start a detached (-d) and interactive (-it) container `hadoop-worker-n` that connects to `hadoop-net`.
```bash
docker run -dit \
  --name hadoop-worker-n \
  --hostname hadoop-worker-n \
  --network hadoop-net \
  zzhou612/hadoop-cluster:latest
```

6. On `manager`, start Hadoop and run the WordCount example in container `hadoop-master`.
```bash
./docker-start-container.sh
./run-wordcount.sh
```
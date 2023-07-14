# Hadoop Cluster
A Hadoop cluster consists of multiple (N) Docker containers (1 master and N-1 workers).

- [x] Deploy a Hadoop cluster on a single machine with multiple Docker containers.
- [x] Deploy a fully distributed Hadoop cluster on multiple host machines by connecting the standalone containers with Docker swarm overlay network.
- [ ] Support common libraries for big data

### Deploy & Test Hadoop Cluster Locally

1. Build docker image.
```bash
mkdir -p .config && cp ~/.ssh/{id_rsa,id_rsa.pub} .config
./download.sh
./build/docker-build-image.sh
```

2. Init docker and create a Hadoop network.
```bash
docker system prune
master/init_swarm.sh # does not work on manjaro
master/init_network.sh
```

3. Start containers.
```bash
./standalone.sh
```

4. Run WordCount example in `hadoop-master` container.
```bash
./run-wordcount.sh
```

### Deploy Hadoop Cluster on Multiple Host Machines

1. Build docker image.
```bash
./download.sh
./docker-build-image.sh
```

2. On `manager`, initialize the swarm.
```bash
docker system prune
master/init_swarm.sh
```

3. On `worker-n`, join the swarm. If the host only has one network interface, the --advertise-addr flag is optional.
```bash
docker system prune
worker/join_swarm.sh <TOKEN> <IP-ADDRESS-OF-MANAGER>
```

4. On `manager`, create an attachable overlay network called `hadoop-net`.
```bash
master/init_network.sh
```

5. On `manager`, start an interactive (-it) container `hadoop-master` that connects to `hadoop-net`.
```bash
export WORKER_NUMBER=N
master/start.sh
```

6. On `worker-n`, start a detached (-d) and interactive (-it) container `hadoop-worker-n` that connects to `hadoop-net`.
```bash
export WORKER_NUMBER=N
export WORKER_ID=X
worker/start.sh
```

7. Record the ssh key of the `manager` node and copy them to the `worker` nodes.
```bash
## first find hadoop-master container id by 'docker container ls' on master host
hadoopuser@hadoop-master-host $ docker exec -it $HOST_CONTAINER_ID bash
root@hadoop-master # cat .ssh/id_rsa.pub

## then copy key to worker host(s)
hadoopuser@hadoop-worker-X-host $ docker exec -it $WORKER_CONTAINER_ID bash
root@hadoop-worker-X # echo $SSH_PUBLIC_KEY > .ssh/authorized_keys
```

8. Start NameNode daemon, DataNode daemon, ResourceManager daemon and NodeManager daemon in `hadoop-master` container.
```bash
master/start_hadoop.sh
```

9. Run WordCount example in `hadoop-master` container.
```bash
./run-wordcount.sh
```

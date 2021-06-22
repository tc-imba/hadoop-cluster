#!/bin/bash

echo "init overlay network"
docker network create --driver=overlay --attachable hadoop-net

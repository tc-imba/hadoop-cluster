#!/bin/bash

echo "clean hadoop-master"
docker-compose -p hadoop-master rm
docker network rm hadoop-net
